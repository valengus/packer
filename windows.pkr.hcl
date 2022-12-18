variable "cloud_token" {
  type    = string
  default = "${env("CLOUD_TOKEN")}"
}

locals {
  # packerstarttime         = formatdate("YYYY.MM.DD", timestamp())
  packerstarttime         = "2022.12.18"
  administrator_password  = "vagrant"
  user                    = "vagrant"
  user_password           = "vagrant"
  cpus                    = 2
  memory                  = 4096
  disk_size               = 61440
  headless                = true
  shutdown_command        = "C:\\Windows\\Temp\\packerShutdown.bat"


  builds = {

    windows10-22h2-x64-pro = {
      vb_guest_os_type     = "Windows10_64"
      vmware_guest_os_type = "windows9-64"
      iso_url              = "https://tb.rg-adguard.net/dl.php?go=f2951538"
      iso_checksum         = "sha1:af8d0e9efd3ef482d0ab365766e191e420777b2b"
      autounattend        = {
        image_name              = "Windows 10 Pro"
        administrator_password  = "${local.administrator_password}"
        user                    = "${local.user}"
        user_password           = "${local.user_password}"
        user_data_key           = "<Key />"
      }
      version_description = {
        box_name                = "WINDOWS 10 22H2 Pro x64"
        date                    = "${local.packerstarttime}"
        administrator_password  = "${local.administrator_password}"
        user                    = "${local.user}"
        user_password           = "${local.user_password}"
      }
    }

    windows-2022-standard = {
      vb_guest_os_type     = "Windows2019_64"
      vmware_guest_os_type = "windows9srv-64"
      iso_url              = "https://software-download.microsoft.com/download/sg/20348.169.210806-2348.fe_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"
      iso_checksum         = "sha1:4e38d098d79f7281251ce61707f73b5e9185c509"
      autounattend      = {
        image_name              = "Windows Server 2022 SERVERSTANDARD"
        administrator_password  = "${local.administrator_password}"
        user                    = "${local.user}"
        user_password           = "${local.user_password}"
        user_data_key           = ""
      }
      version_description = {
        box_name                = "Windows SERVER 2022 STANDARD"
        date                    = "${local.packerstarttime}"
        administrator_password  = "${local.administrator_password}"
        user                    = "${local.user}"
        user_password           = "${local.user_password}"
      }
    }

    windows-2022-standard-core = {
      vb_guest_os_type     = "Windows2019_64"
      vmware_guest_os_type = "windows9srv-64"
      iso_url              = "https://software-download.microsoft.com/download/sg/20348.169.210806-2348.fe_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"
      iso_checksum         = "sha1:4e38d098d79f7281251ce61707f73b5e9185c509"
      user                 = "${local.user}"
      user_password        = "${local.user_password}"
      autounattend      = {
        image_name              = "Windows Server 2022 SERVERSTANDARDCORE"
        administrator_password  = "${local.administrator_password}"
        user                    = "${local.user}"
        user_password           = "${local.user_password}"
        user_data_key           = ""
      }
      version_description = {
        box_name                = "Windows SERVER CORE 2022"
        date                    = "${local.packerstarttime}"
        administrator_password  = "${local.administrator_password}"
        user                    = "${local.user}"
        user_password           = "${local.user_password}"
      }
    }

  }

}

source "virtualbox-iso" "windows" {
  headless              = "${local.headless}"  
  guest_additions_mode  = "disable"
  cd_files              = ["scripts"]
  cpus                  = "${local.cpus}"
  memory                = "${local.memory}"
  disk_size             = "${local.disk_size}"
  boot_wait             = "10s"
  keep_registered       = false
  skip_export           = false
  format                = "ovf"
  communicator          = "winrm"
  winrm_timeout         = "60m"
  winrm_insecure        = true
  winrm_use_ssl         = false
  winrm_password        = "${local.administrator_password}"
  winrm_username        = "Administrator"
  shutdown_command      = "${local.shutdown_command}"
  post_shutdown_delay   = "15m"
}

source "qemu" "windows" {
  accelerator         = "kvm"
  communicator        = "winrm"
  cd_files            = ["drivers/qemu/*","scripts"]
  cpus                = "${local.cpus}"
  memory              = "${local.memory}"
  disk_size           = "${local.disk_size}"
  disk_cache          = "writeback"
  disk_discard        = "ignore"
  disk_interface      = "virtio"
  format              = "qcow2"
  headless            = "${local.headless}"
  vnc_bind_address    = "0.0.0.0"
  shutdown_command    = "${local.shutdown_command}"
  shutdown_timeout    = "15m"
  use_default_display = false
  winrm_timeout       = "60m"
  winrm_no_proxy      = true
  winrm_insecure      = true
  winrm_use_ssl       = false
  winrm_password      = "${local.administrator_password}"
  winrm_username      = "Administrator"
}

source "vmware-iso" "windows" {
  communicator                   = "winrm"
  cd_files                       = ["scripts"]
  cpus                           = "${local.cpus}"
  memory                         = "${local.memory}"
  disk_size                      = "${local.disk_size}"
  disk_adapter_type              = "lsisas1068"
  vmx_remove_ethernet_interfaces = true
  headless                       = "${local.headless}"
  shutdown_command      = "${local.shutdown_command}"
  shutdown_timeout               = "15m"
  winrm_timeout                  = "60m"
  winrm_insecure                 = true
  winrm_use_ssl                  = false
  winrm_password                 = "${local.administrator_password}"
  winrm_username                 = "Administrator"
  disable_vnc                    = true
  disk_type_id                   = 0
}

build {
  name = "windows"

  dynamic "source" {
    for_each = local.builds

    labels   = ["source.virtualbox-iso.windows"]

    content {
      name              = source.key
      vm_name           = source.key
      iso_url           = source.value.iso_url
      iso_checksum      = source.value.iso_checksum
      guest_os_type     = source.value.vb_guest_os_type
      output_directory  = "output/virtualbox-iso_${source.key}"
      cd_content        = {
        "/autounattend.xml" = templatefile("${path.root}/unattend/autounattend.pkrtpl", source.value),
        "/unattend.xml"     = templatefile("${path.root}/unattend/unattend.pkrtpl", source.value),
        "/windows.template" = templatefile("vagrant/windows.tmpl", { user = local.user, user_password = local.user_password })
      }
    }
  }

  dynamic "source" {
    for_each = local.builds
    labels   = ["source.qemu.windows"]
    content {
      name              = source.key
      vm_name           = source.key
      iso_url           = source.value.iso_url
      iso_checksum      = source.value.iso_checksum
      output_directory  = "output/qemu_${source.key}"
      cd_content        = {
        "/autounattend.xml" = templatefile("${path.root}/unattend/autounattend.pkrtpl", source.value),
        "/unattend.xml"     = templatefile("${path.root}/unattend/unattend.pkrtpl", source.value),
        "/windows.template" = templatefile("vagrant/windows.tmpl", { user = local.user, user_password = local.user_password })
      }
    }
  }

  dynamic "source" {
    for_each = local.builds
    labels   = ["source.vmware-iso.windows"]
    content {
      name              = source.key
      vm_name           = source.key
      iso_url           = source.value.iso_url
      iso_checksum      = source.value.iso_checksum
      guest_os_type     = source.value.vmware_guest_os_type
      output_directory  = "output/vmware_${source.key}"
      cd_content        = {
        "/autounattend.xml" = templatefile("${path.root}/unattend/autounattend.pkrtpl", source.value),
        "/unattend.xml"     = templatefile("${path.root}/unattend/unattend.pkrtpl", source.value),
        "/windows.template" = templatefile("vagrant/windows.tmpl", { user = local.user, user_password = local.user_password })
      }
    }
  }

  provisioner "file" {
    destination = "C:/scripts/ConfigureRemotingForAnsible.ps1"
    source      = "scripts/ConfigureRemotingForAnsible.ps1"
  }

  provisioner "file" {
    source      =  "E:/windows.template"
    destination =  "vagrant/windows.template"
    direction   =  "download"
  }

  provisioner "ansible" {
    playbook_file   = "ansible/windows/main.yml"
    use_proxy       = false
    user            = "Administrator"
    extra_arguments = [ "-e", "winrm_password=${build.Password}" ] 
  }

  provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
  }

  provisioner "file" {
    destination = "C:/Windows/Temp/packerShutdown.bat"
    source      = "scripts/packerShutdown.bat"
  }

  post-processors {

    post-processor "vagrant" {
      compression_level    = 9
      output               = "${source.name}-${source.type}.box"
      vagrantfile_template = "vagrant/windows.template"
    }

    # TEST
    post-processor "shell-local" {
      inline = ["vagrant box add --force ${source.name} ${source.name}-${source.type}.box"]
    }
    post-processor "shell-local" {
      inline = [ 
        "bash -c \"if [[ $PACKER_BUILDER_TYPE == 'qemu' ]]; then vagrant up ${source.name} --provider=libvirt ; fi\"",
        "bash -c \"if [[ $PACKER_BUILDER_TYPE == 'virtualbox-iso' ]]; then vagrant up ${source.name} --provider=virtualbox ; fi\"",
        "bash -c \"if [[ $PACKER_BUILDER_TYPE == 'vmware-iso' ]]; then vagrant up ${source.name} --provider=vmware_desktop ; fi\""
      ]
    }
    post-processor "shell-local" {
      inline = ["vagrant destroy -f"]
    }

    post-processor "vagrant-cloud" {
      access_token        = "${var.cloud_token}"
      box_tag             = "valengus/${source.name}"
      version             = "1.0.${local.packerstarttime}"
      version_description = templatefile("${path.root}/vagrant/version_description.md", source.value)
      no_release          = false
    }

  }

}


#### RELEASE
variable "release_box" {
  type    = string
  default = "${env("RELEASE_BOX")}"
}

variable "release_box_tag" {
  type    = string
  default = "${env("RELEASE_BOX_TAG")}"
}

source "null" "release" {
  communicator = "none"
}

build {
  sources = ["source.null.release"]

  post-processors {

    post-processor "artifice" {
      files = ["./${var.release_box}"]
    }

    post-processor "vagrant-cloud" {
      access_token        = "${var.cloud_token}"
      box_tag             = "valengus/${var.release_box_tag}"
      version             = "1.0.${local.packerstarttime}"
      # version_description = "${local.version_description}"
      no_release          = false
    }

  }

}