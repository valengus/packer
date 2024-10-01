# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.provision "shell", privileged: "true", powershell_elevated_interactive: "true", path: "scripts/testScript.ps1"

  config.vm.define "windows11" do |config|
    config.vm.box  = "windows11"
  end


end
