class php {
  # Instalar dependencias en Ubuntu
  exec { 'install-dep-ubu': 
    command => '/usr/bin/apt install software-properties-common apt-transport-https ca-certificates lsb-release -y'
  }

  # Añadir repositorio de PHP
  exec { 'add-source-repo': 
    command => '/usr/bin/add-apt-repository ppa:ondrej/php',
    require => Exec['install-dep-ubu']
  }

  # Instalar PHP 8.2
  package { 'php8.2':
    ensure => installed,
    require => Exec['add-source-repo']
  }

  # Instalar módulos-extensiones para Mysql y Apache
  exec { 'php-mods':
    command => '/usr/bin/apt install php8.2-gd php8.2-zip php8.2-fpm php8.2-common php8.2-imap php8.2-redis php8.2-xml php8.2-mbstring php8.2-curl php8.2-mysql libapache2-mod-php8.2 -y',
    require => Package['php8.2']
  }

  # Habilitar la configuración de PHP-FPM y que Apache trabaje con la versión de PHP instalada
  exec { 'enable-mod-php':
    command => '/usr/sbin/a2enconf php8.2-fpm && /usr/sbin/a2enmod php8.2',
    require => Exec['php-mods']
  }

  # Descomentar la extensión MYSQLI del archivo [php.ini]
  exec { 'enable-mod-mysqli-phpini':
    command => "/usr/bin/sed -i 's/;extension=mysqli/extension=mysqli/' /etc/php/8.2/cli/php.ini && /usr/bin/sed -i 's/;extension=mysqli/extension=mysqli/' /etc/php/8.2/apache2/php.ini",
    require => Exec['enable-mod-php']
  }

  # Reiniciar Apache para que surta efecto la extensión MYSQLI habilitada
  exec { 'reload-apache':
    command => "/usr/sbin/service apache2 reload",
    require => Exec['enable-mod-mysqli-phpini']
  }

  # Copiar archivo [info.php] para probar la configuración y habilitación de PHP y sus extensiones
  file { "${base_site}/info.php":
    ensure => file,
    content => '<?php  phpinfo(); ?>',
    require => Package['apache2']
  }

  # Lanzar notificación de que fue exitosa la instalación y configuración de PHP
  notify { 'php-installed':
    message => 'PHP was installed successfully...',
    require => Exec['enable-mod-mysqli-phpini']
  }
}
