# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "windows10-22h2-x64-pro" do |config|
    config.vm.box  = "windows10-22h2-x64-pro"
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.provision "shell", privileged: "true", powershell_elevated_interactive: "true", path: "scripts/testBox.ps1"
  end

  config.vm.define "windows10-22h2-x64" do |config|
    config.vm.box  = "windows10-22h2-x64"
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.provision "shell", privileged: "true", powershell_elevated_interactive: "true", path: "scripts/testBox.ps1"
  end

  config.vm.define "windows11-22h2-x64-pro" do |config|
    config.vm.box  = "windows11-22h2-x64-pro"
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.provision "shell", privileged: "true", powershell_elevated_interactive: "true", path: "scripts/testBox.ps1"
  end

  config.vm.define "windows-2022-standard" do |config|
    config.vm.box  = "windows-2022-standard"
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.provision "shell", privileged: "true", powershell_elevated_interactive: "true", path: "scripts/testBox.ps1"
  end

  config.vm.define "windows-2022-standard-core" do |config|
    config.vm.box  = "windows-2022-standard-core"
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.provision "shell", privileged: "true", powershell_elevated_interactive: "true", path: "scripts/testBox.ps1"
  end


  # config.vm.define "windows-osbuilder" do |config|
  #   config.vm.box        = "valengus/windows-2022-standard"
  #   config.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct:true
  #   config.disksize.size = '125GB'
  #   config.vm.provider "virtualbox" do |virtualbox|
  #     virtualbox.customize ['modifyvm', :id, '--nested-hw-virt', 'on']
  #     virtualbox.cpus    = 4
  #     virtualbox.memory  = 6144
  #   end
  #   config.vm.provision "ansible" , run: "always" do |ansible|
  #     ansible.playbook = "ansible/osbuilder/windows.yml"
  #   end
  # end

end