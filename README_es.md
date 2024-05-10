## Instalar Apache | PHP | Mysql | WordPress usando Puppet Agent

Automatizar la instalación de un servidor WordPress, utilizando como servidor destino una máquina virtual gestionada con **Vagrant**, utilizando **Puppet** para la instalación y configuración de paquetes.

La configuración deberá permitir acceder al servidor y muestre directamente un blog con un tema aplicado por defecto.

---

### 1. Manifiesto principal de Puppet
   - [default.pp](manifests/default.pp)

### 2. Módulos configurados en Puppet
   - [Apache](modules/apache/manifests/init.pp)
   - [php](modules/php/manifests/init.pp)
   - [mysql](modules/mysql/manifests/init.pp)
   - [wordpress](modules/wordpress/manifests/init.pp)

### 3. Archivo de configuración de Vagrant
   - [Vagrantfile](Vagrantfile)

### 4. Iniciar Maquina Virtual con Ubuntu Server 22.04
   - `vagrant init bento/ubuntu-22.04`
   - `vagrant up`
   - Al finalizar hacemos un test en el browser: `http://localhost:8080`
