# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
config.vm.define :web do |web|
web.vm.box = "bento/ubuntu-22.04"
web.vm.network :private_network, ip: "192.168.56.2"
web.vm.hostname = "web"
web.vm.provision "shell", path: "provision-web.sh"
end
config.vm.define :db do |db|
db.vm.box = "bento/ubuntu-22.04"
db.vm.network :private_network, ip: "192.168.56.3"
db.vm.hostname = "db"
db.vm.provision "shell", path: "provision-db.sh"
end
end