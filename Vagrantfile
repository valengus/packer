# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "windows10-22h2-x64-pro" do |config|
    config.vm.box  = "windows10-22h2-x64-pro"
    config.vm.provision "shell", privileged: "true", powershell_elevated_interactive: "true", path: "scripts/testBox.ps1"
  end

  config.vm.define "windows-2022-standard" do |config|
    config.vm.box  = "windows-2022-standard"
    config.vm.provision "shell", privileged: "true", powershell_elevated_interactive: "true", path: "scripts/testBox.ps1"
  end


  config.vm.define "windows-2022-standard-core" do |config|
    config.vm.box  = "windows-2022-standard-core"
    config.vm.provision "shell", privileged: "true", powershell_elevated_interactive: "true", path: "scripts/testBox.ps1"
  end

  # config.vm.define "windows-osbuilder" do |config|
  #   config.vm.box        = "windows-2022-standard"
  #   config.vm.provider :libvirt do |libvirt|
  #     libvirt.qemu_use_session           = false
  #     libvirt.cpus                       = 4
  #     libvirt.memory                     = 6144
  #     libvirt.nested                     = true
  #     libvirt.cpu_mode                   = "host-model"
  #     libvirt.machine_virtual_size       = 125
  #   end
  #   config.vm.provision "ansible" , run: "always" do |ansible|
  #     ansible.playbook = "ansible/osbuilder/windows.yml"
  #   end
  # end

end