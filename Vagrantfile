# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "windows-11-25h2-audit-mode" do |config|
    config.vm.box  = "windows-11-25h2-audit-mode"
    config.vm.provider :virtualbox do |virtualbox|
      virtualbox.cpus   = 4
      virtualbox.memory = 8192
    end
    config.vm.synced_folder "scripts", "C:/scripts", type: "virtualbox"
    config.vm.synced_folder "unattend", "C:/unattend", type: "virtualbox"
  end

end