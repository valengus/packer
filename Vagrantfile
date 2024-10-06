# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|


  config.vm.provider :libvirt do |libvirt|
    libvirt.cpus      = 2
    libvirt.memory    = 4096
  end
  config.vm.provider :virtualbox do |virtualbox|
    virtualbox.cpus   = 2
    virtualbox.memory = 4096
  end
  config.vm.provider :vmware_desktop do |v, override|
    v.vmx["numvcpus"] = "2"
    v.vmx["memsize"]  = "4096"
  end
    config.vm.provider "hyperv" do |hyperv|
    hyperv.cpus       = 2
    hyperv.memory     = 4096
    hyperv.maxmemory  = 4096
  end
  config.vm.provision "shell", privileged: "true", powershell_elevated_interactive: "true", path: "scripts/testVagrantBox.ps1"

  
  config.vm.define "windows11" do |config|
    config.vm.box  = "windows11"
  end

  config.vm.define "windows-2022-standard" do |config|
    config.vm.box  = "windows-2022-standard"
  end

  config.vm.define "windows-2022-standard-core" do |config|
    config.vm.box  = "windows-2022-standard-core"
  end

end
