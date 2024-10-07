packer {
  required_plugins {
    hyperv = {
      source  = "github.com/hashicorp/hyperv"
      version = "~> 1"
    }
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
    vmware = {
      version = "~> 1"
      source = "github.com/hashicorp/vmware"
    }
    vagrant = {
      version = "~> 1"
      source = "github.com/hashicorp/vagrant"
    }
  }
}

variable "client_id" {
  type    = string
  default = "${env("HCL_CLIENT_ID")}"
}

variable "client_secret" {
  type    = string
  default = "${env("HCL_CLIENT_secret")}"
}

variable "headless" {
  type    = bool
  default = true
}

variable "keep_registered" {
  type    = bool
  default = false
}

locals {
  # packerstarttime = formatdate("YYYYMMDD", timestamp())
  packerstarttime = "20241001"
  builds          = {

    windows-11-22h2 = {
      iso_url              = "https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66751/22621.525.220925-0207.ni_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
      iso_checksum         = "sha256:ebbc79106715f44f5020f77bd90721b17c5a877cbc15a3535b99155493a1bb3f"
      vb_guest_os_type     = "Windows11_64"
      vmware_guest_os_type = "windows11-64"
      autounattend = {
        image_name              = "Windows 11 Enterprise Evaluation"
        user_data_key           = ""
      }
    }

    # windows-11-24h2 = {
    #   iso_url              = "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26100.1742.240906-0331.ge_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
    #   iso_checksum         = "sha256:755a90d43e826a74b9e1932a34788b898e028272439b777e5593dee8d53622ae"
    #   vb_guest_os_type     = "Windows11_64"
    #   vmware_guest_os_type = "windows11-64"
    #   autounattend = {
    #     image_name              = "Windows 11 Enterprise Evaluation"
    #     user_data_key           = ""
    #   }
    # }

    windows-2022-standard = {
      iso_url              = "https://software-static.download.prss.microsoft.com/sg/download/888969d5-f34g-4e03-ac9d-1f9786c66749/SERVER_EVAL_x64FRE_en-us.iso"
      iso_checksum         = "sha256:3e4fa6d8507b554856fc9ca6079cc402df11a8b79344871669f0251535255325"
      vb_guest_os_type     = "Windows2022_64"
      vmware_guest_os_type = "windows2019srv_64Guest"
      autounattend      = {
        image_name              = "Windows Server 2022 SERVERSTANDARD"
        user_data_key           = ""
      }
    }

    windows-2022-standard-core = {
      vb_guest_os_type     = "Windows2022_64"
      vmware_guest_os_type = "windows2019srv_64Guest"
      iso_url              = "https://software-static.download.prss.microsoft.com/sg/download/888969d5-f34g-4e03-ac9d-1f9786c66749/SERVER_EVAL_x64FRE_en-us.iso"
      iso_checksum         = "sha256:3e4fa6d8507b554856fc9ca6079cc402df11a8b79344871669f0251535255325"
      autounattend      = {
        image_name              = "Windows Server 2022 SERVERSTANDARDCORE"
        user_data_key           = ""
      }
    }

  }
}

source "qemu" "windows" {
  keep_registered     = "${var.keep_registered}"
  accelerator         = "kvm"
  output_directory    = "builds/${source.type}-${source.name}"
  cpus                = 4
  memory              = 8 * 1024
  disk_size           = 60 * 1024
  headless            = "${var.headless}"
  vnc_bind_address    = "0.0.0.0"
  shutdown_command    = "C:\\Windows\\Temp\\packerShutdown.bat"
  shutdown_timeout    = "15m"
  use_default_display = false
  communicator        = "winrm"
  winrm_timeout       = "60m"
  winrm_insecure      = true
  winrm_use_ssl       = false
  winrm_username      = "Administrator"
  winrm_password      = "password"
}

source "hyperv-iso" "windows" {
  keep_registered       = "${var.keep_registered}"
  output_directory      = "builds/${source.type}-${source.name}"
  boot_wait             = "2s"
  cpus                  = 4
  memory                = 8 * 1024
  disk_size             = 60 * 1024
  headless              = "${var.headless}"
  communicator          = "winrm"
  winrm_timeout         = "60m"
  winrm_insecure        = true
  winrm_use_ssl         = false
  winrm_username        = "Administrator"
  winrm_password        = "password"
  enable_dynamic_memory = false
  enable_secure_boot    = false
  guest_additions_mode  = "disable"
  switch_name           = "Default switch"
  generation            = "1"
  configuration_version = "10.0"
  shutdown_command      = "C:\\Windows\\Temp\\packerShutdown.bat"
}

source "virtualbox-iso" "windows" {
  keep_registered       = "${var.keep_registered}"
  output_directory      = "builds/${source.type}-${source.name}"
  headless              = "${var.headless}"
  guest_additions_mode  = "disable"
  cpus                  = 4
  memory                = 8 * 1024
  disk_size             = 60 * 1024
  boot_wait             = "2s"
  format                = "ovf"
  communicator          = "winrm"
  winrm_timeout         = "60m"
  winrm_insecure        = true
  winrm_use_ssl         = false
  winrm_username        = "Administrator"
  winrm_password        = "password"
  shutdown_command      = "C:\\Windows\\Temp\\packerShutdown.bat"
  post_shutdown_delay   = "15m"
}

source "vmware-iso" "windows" {
  keep_registered                = "${var.keep_registered}"
  output_directory               = "builds/${source.type}-${source.name}"
  boot_wait                      = "2s"
  cpus                           = 4
  memory                         = 8 * 1024
  disk_size                      = 60 * 1024
  disk_adapter_type              = "lsisas1068"
  vmx_remove_ethernet_interfaces = true
  headless                       = "${var.headless}"
  shutdown_command               = "C:\\Windows\\Temp\\packerShutdown.bat"
  shutdown_timeout               = "15m"
  communicator                   = "winrm"
  winrm_timeout                  = "60m"
  winrm_insecure                 = true
  winrm_use_ssl                  = false
  winrm_username                 = "Administrator"
  winrm_password                 = "password"
  disable_vnc                    = false
  vnc_port_max                   =  5980
  vnc_port_min                   =  5900
  disk_type_id                   = 0
  version                        = 14
  network_adapter_type           = "e1000"
  vmx_data                       = {
    "RemoteDisplay.vnc.enabled" = "false",
    "RemoteDisplay.vnc.port"    = true
  }
}

build {
  name = "windows"

  dynamic "source" {
    for_each = local.builds
    labels   = ["source.qemu.windows"]
    content {
      name              = source.key
      vm_name           = source.key
      boot_command      = ["<spacebar><wait><spacebar><wait><spacebar>"]
      iso_url           = source.value.iso_url
      iso_checksum      = source.value.iso_checksum
      cd_files          = [
        "salt", "drivers/qemu/*", "scripts" 
      ]
      cd_content        = {
        "/autounattend.xml" = templatefile("${path.root}/unattend/autounattend.pkrtpl", source.value),
        "/unattend.xml"     = templatefile("${path.root}/unattend/unattend.pkrtpl", source.value),
      }
    }
  }

  dynamic "source" {
    for_each = local.builds
    labels   = ["source.hyperv-iso.windows"]
    content {
      name              = source.key
      vm_name           = source.key
      boot_command      = ["<spacebar><wait><spacebar><wait><spacebar>"]
      iso_url           = source.value.iso_url
      iso_checksum      = source.value.iso_checksum
      cd_files          = [
        "salt", "scripts" 
      ]
      cd_content        = {
        "/autounattend.xml" = templatefile("${path.root}/unattend/autounattend.pkrtpl", source.value),
        "/unattend.xml"     = templatefile("${path.root}/unattend/unattend.pkrtpl", source.value),
      }
    }
  }

  dynamic "source" {
    for_each = local.builds
    labels   = ["source.virtualbox-iso.windows"]
    content {
      name              = source.key
      vm_name           = source.key
      boot_command      = ["<spacebar><wait><spacebar><wait><spacebar>"]
      guest_os_type     = source.value.vb_guest_os_type
      iso_url           = source.value.iso_url
      iso_checksum      = source.value.iso_checksum
      cd_files          = [
        "salt", "scripts" 
      ]
      cd_content        = {
        "/autounattend.xml" = templatefile("${path.root}/unattend/autounattend.pkrtpl", source.value),
        "/unattend.xml"     = templatefile("${path.root}/unattend/unattend.pkrtpl", source.value),
      }
    }
  }

  dynamic "source" {
    for_each = local.builds
    labels   = ["source.vmware-iso.windows"]
    content {
      name              = source.key
      vm_name           = source.key
      boot_command      = ["<spacebar><wait><spacebar><wait><spacebar>"]
      guest_os_type     = source.value.vmware_guest_os_type
      iso_url           = source.value.iso_url
      iso_checksum      = source.value.iso_checksum
      cd_files          = [
        "salt", "scripts" 
      ]
      cd_content        = {
        "/autounattend.xml" = templatefile("${path.root}/unattend/autounattend.pkrtpl", source.value),
        "/unattend.xml"     = templatefile("${path.root}/unattend/unattend.pkrtpl", source.value),
      }
    }
  }

  # wait salt process exit code
  provisioner "powershell" {
    inline = [
      "$saltProcess = Get-Process salt-call ; Wait-Process -InputObject $saltProcess ; if ($saltProcess.ExitCode -ne 0) { exit 1 }",
      "Get-Service salt-minion | Set-Service -StartupType Disabled",
      "Start-Sleep -Seconds 30"
    ]
  }

  provisioner "powershell" {
    inline = [
      "Stop-Service -Name wuauserv -Force -Confirm:$False",
      "Remove-Item C:\\Windows\\SoftwareDistribution\\Download -Recurse -Force",
      "New-Item -Path HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\WindowsUpdate\\AU -Force",
      "Set-ItemProperty -Path HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\WindowsUpdate\\AU -Name NoAutoUpdate -Value 1"
    ]
  }

  provisioner "powershell" {
    script = "scripts/virtioDrivers.ps1"
    only   = [ "qemu.windows-11-22h2", "qemu.windows-2022-standard", "qemu.windows-2022-standard-core" ]
  }

  provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'Restarted.'}\""
    restart_timeout       = "15m"
    check_registry        = true
  }

  provisioner "powershell" {
    inline = [
      "Optimize-Volume -DriveLetter C -Defrag -Verbose",
      "sdelete -z C:"
    ]
  }

  provisioner "powershell" {
    inline = [ "Get-Service salt-minion | Set-Service -StartupType Automatic" ]
  }

  provisioner "file" {
    destination = "C:/scripts/ConfigureRemotingForAnsible.ps1"
    source      = "scripts/ConfigureRemotingForAnsible.ps1"
  }

  provisioner "file" {
    destination = "C:/Windows/Temp/packerShutdown.bat"
    source      = "scripts/packerShutdown.bat"
  }

  post-processors {

    post-processor "vagrant" {
      compression_level    = 9
      output               = "boxes/${source.type}/${source.name}.box"
      vagrantfile_template = "vagrant/windows.template"
    }

    post-processor "shell-local" {
      inline = ["vagrant box add --force ${source.name} boxes/${source.type}/${source.name}.box"]
    }

    post-processor "shell-local" {
      inline            = [ "vagrant up ${source.name} --provider=libvirt" ]
      only              = [ "qemu.windows-11-22h2", "qemu.windows-2022-standard", "qemu.windows-2022-standard-core" ]
      environment_vars  = [ "VAGRANT_DEFAULT_PROVIDER=libvirt" ]
    }

    post-processor "shell-local" {
      inline            = [ "vagrant up ${source.name} --provider=hyperv" ]
      only              = [ "hyperv-iso.windows-11-22h2", "hyperv-iso.windows-2022-standard", "hyperv-iso.windows-2022-standard-core" ]
      environment_vars  = [ "VAGRANT_DEFAULT_PROVIDER=hyperv" ]
    }

    post-processor "shell-local" {
      inline            = [ "vagrant up ${source.name} --provider=virtualbox" ]
      only              = [ "virtualbox-iso.windows-11-22h2", "virtualbox-iso.windows-2022-standard", "virtualbox-iso.windows-2022-standard-core" ]
      environment_vars  = [ "VAGRANT_DEFAULT_PROVIDER=virtualbox" ]
    }

    post-processor "shell-local" {
      inline            = [ "vagrant up ${source.name} --provider=vmware_desktop" ]
      only              = [ "vmware-iso.windows-11-22h2", "vmware-iso.windows-2022-standard", "vmware-iso.windows-2022-standard-core" ]
      environment_vars  = [ "VAGRANT_DEFAULT_PROVIDER=vmware_desktop" ]
    }

    post-processor "shell-local" {
      inline = ["vagrant destroy -f"]
    }

    post-processor "vagrant-registry" {
      client_id     = "${var.client_id}"
      client_secret = "${var.client_secret}"
      box_tag       = "valengus/${source.name}"
      version       = "1.1.${local.packerstarttime}"
      architecture  = "amd64"
      no_release    = true
    }

  }

}
