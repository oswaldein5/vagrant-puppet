## Install Apache | PHP | Mysql | WordPress using Puppet Agent

Automate the installation of a WordPress server, using as target server a virtual machine managed with **Vagrant**, using **Puppet** for the installation and configuration of packages.

The configuration should allow access to the server and directly display a blog with a default theme applied.

---

### 1. Puppet default manifest
   - [default.pp](manifests/default.pp)

### 2. Modules configured in Puppet
   - [Apache](modules/apache/manifests/init.pp)
   - [php](modules/php/manifests/init.pp)
   - [mysql](modules/mysql/manifests/init.pp)
   - [wordpress](modules/wordpress/manifests/init.pp)

### 3. Vagrant configuration file
   - [Vagrantfile](Vagrantfile)

### 4. Start Virtual Machine with Ubuntu Server 22.04
```sh
vagrant init bento/ubuntu-22.04
vagrant up
http://localhost:8080
```
