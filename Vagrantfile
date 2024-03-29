# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  $testScript = <<-SCRIPT
  # checking if sysprep running
  $sysprep = Get-Process sysprep -ErrorAction SilentlyContinue
  if ($sysprep -eq $null) { exit 0 } else { exit 1 }
  SCRIPT

  $testShellScript = <<-SCRIPT
  sudo dnf update -y
  SCRIPT

  config.vm.define "fedora38" do |config|
    config.vm.box  = "fedora38"
    # config.ssh.username = 'vagrant'
    # config.ssh.password = 'vagrant'
    # config.ssh.insert_key = false
    config.vm.provision "shell", inline: $testShellScript
  end

  config.vm.define "windows10-22h2-x64-pro" do |config|
    config.vm.box  = "windows10-22h2-x64-pro"
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.provision "shell", privileged: "true", powershell_elevated_interactive: "true", inline: $testScript
  end

  # config.vm.define "windows11-22h2-x64-pro" do |config|
  #   config.vm.box  = "windows11-22h2-x64-pro"
  #   config.vm.synced_folder ".", "/vagrant", disabled: true
  #   config.vm.provision "shell", privileged: "true", powershell_elevated_interactive: "true", inline: $testScript
  # end

  config.vm.define "windows10-22h2-x64" do |config|
    config.vm.box  = "windows10-22h2-x64"
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.provision "shell", privileged: "true", powershell_elevated_interactive: "true", inline: $testScript
  end

  config.vm.define "windows11-22h2-x64" do |config|
    config.vm.box  = "windows11-22h2-x64"
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.provision "shell", privileged: "true", powershell_elevated_interactive: "true", inline: $testScript
  end

  config.vm.define "windows-2022-standard" do |config|
    config.vm.box  = "windows-2022-standard"
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.provision "shell", privileged: "true", powershell_elevated_interactive: "true", inline: $testScript
  end

  config.vm.define "windows-2022-standard-core" do |config|
    config.vm.box  = "windows-2022-standard-core"
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.provision "shell", privileged: "true", powershell_elevated_interactive: "true", inline: $testScript
  end

  config.vm.define "windows-osbuilder" do |config|
    config.vm.box            = "valengus/windows-2022-standard"
    config.vm.provider "vmware_desktop" do |vmware_desktop|
      vmware_desktop.gui               = true
      vmware_desktop.vmx["memsize"]    = "8192"  
      vmware_desktop.vmx["numvcpus"]   = "6"
      vmware_desktop.vmx["vhv.enable"] = "TRUE"
    end
    config.vm.provision "ansible" , run: "always" do |ansible|
      ansible.playbook = "ansible/osbuilder/windows.yml"
    end
  end

  config.vm.define "linux-osbuilder" do |config|
    config.vm.box            = "generic/oracle8"

    config.vm.provider "vmware_desktop" do |vmware_desktop|
      vmware_desktop.gui               = true
      vmware_desktop.vmx["memsize"]    = "4096"  
      vmware_desktop.vmx["numvcpus"]   = "2"
      vmware_desktop.vmx["vhv.enable"] = "TRUE"
    end
    # config.vm.provision "ansible" , run: "always" do |ansible|
    #   ansible.playbook = "ansible/osbuilder/oraclelinux.yml"
    # end
  end

end