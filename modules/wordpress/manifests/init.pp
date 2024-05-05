class wordpress {
  # Descargar la última versión de Wordpress [6.5.2]
  exec { 'download-wp':
    command => "/usr/bin/wget https://wordpress.org/latest.tar.gz",
    cwd => $document_root,
    require => Service['mysql']
  }

  # Desempaquetar el archivo [wordpress-6.5.2.tar.gz]
  exec { 'unpack-wp':
    command => "/usr/bin/tar -xvzf ${document_root}/*.tar.gz",
    require => Exec['download-wp']
  }

  # Copiar archivo configuración [wp-config.php] de Wordpress según template [wp-config.php.erb]
  file { 'wp-config':
    path => "${document_root}/wordpress/wp-config.php",
    ensure => present,
    content => template("wordpress/wp-config.php.erb"),
    mode => '600',
    require => Exec['unpack-wp']
  }

  # Cambiar permisos del directorio [wordpress]
  exec { 'chmod-wp':
    command => "/usr/bin/chmod -R 775 ${document_root}/wordpress",
    require => File['wp-config']
  }

  # Cambiar el propietario del directorio [wordpress] a [www-data]
  exec { 'chown-wp':
    command => "/usr/bin/chown -R www-data:www-data ${document_root}/wordpress",
    require => Exec['chmod-wp']
  }

  # Mover directorio [wordpress] a la ruta por defecto donde se alojan los sitios web en Apache [/var/www/html]
  exec { 'mv-wp':
    command => "/usr/bin/mv ${document_root}/wordpress/* ${base_site}",
    require => Exec['chown-wp']
  }

  # Descargar la última versión de WP-CLI [2.10] de Wordpress
  exec { 'download-wpcli':
    command => "/usr/bin/wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar",
    cwd => $document_root,
    require => Exec['mv-wp']
  }

  # Cambiar permisos de ejecución [u+x] y propietario [vagrant] del archivo descargado [wp-cli.phar]
  exec { 'change-wpcli':
    command => "/usr/bin/chmod u+x wp-cli.phar && /usr/bin/chown vagrant:vagrant wp-cli.phar",
    require => Exec['download-wpcli']
  }

  # Mover y renombrar archivo [wp-cli.phar] a [/usr/local/bin/wp]
  exec { 'move-wpcli':
    command => "/usr/bin/mv wp-cli.phar /usr/local/bin/wp",
    require => Exec['change-wpcli']
  }

  # Instalar de forma desatendida Wordpress utilizando WP-CLI
  exec { 'install-wp':
    command => "/usr/local/bin/wp core install --url=${db_host}:${port} --title='Blog | Oswaldo Solano' --admin_name=${wp_admin} --admin_password=${password} --admin_email=${email} --allow-root --path='${base_site}'",
    require => Exec['move-wpcli']
  }

  # Instalar y activar un tema [twentytwentyfour] en WordPress utilizando WP-CLI
  exec { 'activate-theme':
    command => "/usr/local/bin/wp theme install twentytwentyfour --allow-root --path='${base_site}' --activate",
    require => Exec['install-wp']
  }

  # Lanzar notificación de que fue exitosa la instalación y configuración de WordPress
  notify {'wp-installed':
    message => "WordPress was installed successfully...",
    require => Exec['activate-theme']
  }
}
