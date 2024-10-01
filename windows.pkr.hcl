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

locals {
  packerstarttime = formatdate("YYYYMMDD", timestamp())
  builds          = {

    windows11 = {
      # 23H2:
      # iso_url              = "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/22631.2428.231001-0608.23H2_NI_RELEASE_SVC_REFRESH_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
      # iso_checksum         = "sha256:c8dbc96b61d04c8b01faf6ce0794fdf33965c7b350eaa3eb1e6697019902945c"
      # 24H2:
      iso_url              = "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26100.1742.240906-0331.ge_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
      iso_checksum         = "sha256:755a90d43e826a74b9e1932a34788b898e028272439b777e5593dee8d53622ae"
      
      vb_guest_os_type     = "Windows11_64"
      vmware_guest_os_type = "windows11-64"
      autounattend = {
        image_name              = "Windows 11 Enterprise Evaluation"
        administrator_password  = "password"
        user_data_key           = ""
      }
    }

  }
}

source "hyperv-iso" "windows" {
  keep_registered       = true
  output_directory      = "builds/${source.type}-${source.name}"
  boot_wait             = "2s"
  cpus                  = 2
  memory                = 4 * 1024
  disk_size             = 60 * 1024
  headless              = true
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
  output_directory      = "builds/${source.type}-${source.name}"
  keep_registered       = true
  headless              = true
  guest_additions_mode  = "disable"
  cpus                  = 2
  memory                = 4 * 1024
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
  cpus                           = 2
  memory                         = 4 * 1024
  disk_size                      = 60 * 1024
  disk_adapter_type              = "lsisas1068"
  vmx_remove_ethernet_interfaces = true
  headless                       = false
  shutdown_command               = "C:\\Windows\\Temp\\packerShutdown.bat"
  shutdown_timeout               = "15m"
  communicator                   = "winrm"
  winrm_timeout                  = "60m"
  winrm_insecure                 = true
  winrm_use_ssl                  = false
  winrm_username                 = "Administrator"
  winrm_password                 = "password"
  disable_vnc                    = false
  disk_type_id                   = 0
  version                        = 14
  network_adapter_type           = "e1000"
}

build {
  name = "windows"

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
        "salt",
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
        "salt",
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
        "salt",
      ]
      cd_content        = {
        "/autounattend.xml" = templatefile("${path.root}/unattend/autounattend.pkrtpl", source.value),
        "/unattend.xml"     = templatefile("${path.root}/unattend/unattend.pkrtpl", source.value),
      }
    }
  }

  # wait salt-call process
  provisioner "powershell" {
    inline = [
      "Start-Sleep -Seconds 5",
      "$saltProcess = Get-Process salt-call ; Wait-Process -InputObject $saltProcess ; if ($saltProcess.ExitCode -ne 0) { exit 1 }",
      "Get-Service salt-minion | Set-Service -StartupType Disabled",
    ]
  }

  provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'Restarted.'}\""
    restart_timeout       = "15m"
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
      inline = [ "vagrant up ${source.name} --provider=hyperv" ]
      only   = [ "hyperv-iso.windows11" ]
    }

    post-processor "shell-local" {
      inline = [ "vagrant up ${source.name} --provider=virtualbox" ]
      only   = [ "virtualbox-iso.windows11" ]
    }

    post-processor "shell-local" {
      inline = [ "vagrant up ${source.name} --provider=vmware_desktop" ]
      only   = [ "vmware-iso.windows11" ]
    }

    # post-processor "shell-local" {
    #   inline = ["vagrant destroy -f"]
    # }

    # post-processor "vagrant-cloud" {
    #   access_token        = "${var.cloud_token}"
    #   box_tag             = "valengus/${source.name}"
    #   version             = "1.1.${local.packerstarttime}"
    #   no_release          = true
    #   version_description = templatefile("${path.root}/vagrant/${source.name}/version_description.md", { 
    #     date = formatdate("DD.MM.YYYY", timestamp())
    #   } )
    # }

  }

}
