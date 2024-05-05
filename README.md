## Install Apache | PHP | Mysql | WordPress using Puppet Agent

### 1. Check the Vagrant configuration file
   - [Vagrantfile](Vagrantfile)

### 2. Run Virtual Machine with Ubuntu server 22.04
   - `vagrant init bento/ubuntu-22.04`
   - `vagrant up`

### 3. Check the Puppet main manifest
   - [default.pp](manifests/default.pp)

### 4. Modules configured in Puppet
   - [Apache](modules/apache/manifests/init.pp)
   - [php](modules/php/manifests/init.pp)
   - [mysql](modules/mysql/manifests/init.pp)
   - [wordpress](modules/wordpress/manifests/init.pp)