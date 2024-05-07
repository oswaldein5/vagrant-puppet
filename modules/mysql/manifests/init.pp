class mysql {
  # Instalar MYSQL 8
  package { 'mysql-server':
    ensure => installed
  }

  # Asegurar que el servicio de MySQL esté presente, activo y configurado para iniciarse automáticamente en el arranque del sistema
  service { 'mysql':
    name => 'mysql',
    ensure => true,
    enable => true,
    require => Package['mysql-server'],
    restart => '/usr/sbin/service mysql reload'
  }

  # Copiar archivo configuración de MySQL [my.cnf] según template [my.cnf.erb]
  file { '/etc/mysql/my.cnf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('mysql/my.cnf.erb'),
    require => Package['mysql-server'],
    notify  => Service['mysql'],
  }

  # Setear password de usuario root en MySQL
  exec { 'set-mysql-password':
    unless => "/usr/bin/mysqladmin -u ${user_root} -p ${password} status",
    command => "/usr/bin/mysqladmin -u ${user_root} password ${password}",
    require => Service['mysql']
  }

  # Copiar archivo ejecución comandos de MySQL [create-db.sql] según template [create-db.sql.erb]
  file { 'copy-tp-db-mysql':
    path => "${document_root}/create-db.sql",
    ensure => present,
    content => template('mysql/create-db.sql.erb'),
    require => Exec['set-mysql-password']
  }

  # Ejecutar sentencias SQL del archivo [create-db.sql] para la creación de base de datos y usuario que usaran en Wordpress
  exec { 'create-db-mysql':
    command => "/usr/bin/mysql -h ${db_host} -u ${user_root} -D mysql < ${document_root}/create-db.sql",
    require => File['copy-tp-db-mysql']
  }

  # Lanzar notificación de que fue exitosa la instalación y configuración de MySQL
  notify { 'mysql-installed':
    message => 'MySQL was installed successfully...',
    require => Exec['create-db-mysql']
  }
}
