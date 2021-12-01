# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "test" do |config|
    config.vm.hostname         = "test"
    config.vm.box              = "centos/7"
    config.vm.box_check_update = false
    config.vm.provider :libvirt do |v|
      v.qemu_use_session = false
      v.cpus             = 2
      v.memory           = 3072
    end
  end

  config.vm.define "node02" do |config|
    config.vm.hostname         = "node02"
    config.vm.box              = "centos/7"
    config.vm.box_check_update = false
    config.vm.provider :libvirt do |v|
      v.qemu_use_session = false
      v.cpus             = 2
      v.memory           = 3072
    end
  end

end