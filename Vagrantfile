# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "windows11" do |config|
    config.vm.box  = "windows11"
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.provision "shell", privileged: "true", powershell_elevated_interactive: "true", path: "scripts/testVagrantBox.ps1"
  end

  config.vm.define "windows-2022-standard" do |config|
    config.vm.box  = "windows-2022-standard"
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.provision "shell", privileged: "true", powershell_elevated_interactive: "true", path: "scripts/testVagrantBox.ps1"
  end

  config.vm.define "windows-2022-standard-core" do |config|
    config.vm.box  = "windows-2022-standard-core"
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.provision "shell", privileged: "true", powershell_elevated_interactive: "true", path: "scripts/testVagrantBox.ps1"
  end

end
