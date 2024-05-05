class apache {
  # Instalar Apache
  package { 'apache2':
    ensure => installed
  }

  # Eliminar configuraciones por default
  file { ['/etc/apache2/sites-available/000-default.conf', '/etc/apache2/sites-enabled/000-default.conf']:
    ensure => absent,
    require => Package['apache2']
  }

  # Copiar archivo configuración [vagrant.conf] según template [virtual-hosts.conf.erb]
  file { 'replace-tp-vhost':
    path => '/etc/apache2/sites-available/vagrant.conf',
    content => template('apache/virtual-hosts.conf.erb')
  }

  # Crear enlace simbólico que apunta al archivo [/etc/apache2/sites-available/vagrant.conf]
  file { 'link-vagrant-conf':
    path => '/etc/apache2/sites-enabled/vagrant.conf',
    ensure  => link,
    target  => "/etc/apache2/sites-available/vagrant.conf",
    require => File['replace-tp-vhost'],
    notify  => Service['apache2']
  }

  # Eliminar archivo [index.html]
  file { 'remove-index':
    path => "${base_site}/index.html",
    ensure => absent,
    require => File['link-vagrant-conf']
  }

  # Verificar y asegurar la configuración de Apache y si la verificación es exitosa, se reinicia el servicio
  service { 'apache2':
    ensure => running,
    enable => true,
    hasstatus  => true,
    restart => "/usr/sbin/apachectl configtest && /usr/sbin/service apache2 reload"
  }

  # Lanzar notificación de que fue exitosa la instalación y configuración de Apache
  notify { 'apache-installed':
    message => 'Apache was installed successfully...',
    require => Package['apache2']
  }
}
