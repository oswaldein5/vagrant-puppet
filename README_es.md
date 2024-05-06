## Instalar Apache | PHP | Mysql | WordPress usando Puppet Agent
Automatizar la instalación de un servidor WordPress, utilizando como servidor destino una máquina virtual gestionada con Vagrant, configurada para provisionar mediante Puppet.

La configuración deberá permitir acceder al servidor y muestre directamente un blog con un tema aplicado por defecto.

---

### 1. Revisar archivo de configuración de Vagrant
   - [Vagrantfile](Vagrantfile)

### 2. Iniciar Maquina Virtual con Ubuntu Server 22.04
   - `vagrant init bento/ubuntu-22.04`
   - `vagrant up`

### 3. Revisar manifiesto principal de Puppet
   - [default.pp](manifests/default.pp)

### 4. Modulos configurados en Puppet
   - [Apache](modules/apache/manifests/init.pp)
   - [php](modules/php/manifests/init.pp)
   - [mysql](modules/mysql/manifests/init.pp)
   - [wordpress](modules/wordpress/manifests/init.pp)