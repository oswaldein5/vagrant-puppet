# Declaración de variables usadas en todos los modulos de puppet
$document_root = '/home/vagrant'
$base_site = '/var/www/html'
$port = '8080'
$email = 'oswaldo.solano@mail.com'
$user_root = 'root'
$wp_admin = 'wp_admin'

# Passwords should NOT be put in plain text within the manifests, use external modules such as 'hiera' to handle sensitive information
# For the demonstration, a key is used without any form of encryption
$password = 'pass.123'
# NO se deben poner los passwords en texto plano dentro de los manifiestos, usar módulos externos como 'hiera' para el manejo de información sensible
# Para efecto de la demostración se usa una clave sin ninguna forma de cifrado

$db_name = 'wordpress'
$db_user = 'wordpress'
$db_host = 'localhost'

# Declarar los modulos que ira ejecutando puppet de forma secuencial
include apache
include php
include mysql
include wordpress

# Eliminar todos los archivos descargados
Exec { 'clean-all':
  command => "/usr/bin/rm -Rf *",
  cwd => $document_root,
  require => Notify['wp-installed']
}

# Mostrar mensaje de finalización de la provisión/instalación de WordPress
notify { 'installation-successful':
  message => "Installation successful, access to http://${db_host}:${port}",
  require => Notify['wp-installed']
}
