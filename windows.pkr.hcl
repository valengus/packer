packer {
  required_plugins {
    vmware = {
      version = "~> 1"
      source = "github.com/hashicorp/vmware"
    }
    hyperv = {
      version = "~> 1"
      source  = "github.com/hashicorp/hyperv"
    }
    qemu = {
      version = "~> 1.1.0"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

variable "cloud_token" {
  type    = string
  default = "${env("CLOUD_TOKEN")}"
}

variable "headless" {
  type    = bool
  default = true
}

variable "cpus" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 4096
}

locals {
  # packerstarttime         = formatdate("YYYYMMDD", timestamp())
  packerstarttime         = "20240520"
  administrator_password  = "vagrant"
  user                    = "vagrant"
  user_password           = "vagrant"
  cpus                    = "${var.cpus}"
  memory                  = "${var.memory}"
  disk_size               = 60 * 1024
  headless                = "${var.headless}"
  shutdown_command        = "C:\\Windows\\Temp\\packerShutdown.bat"

  builds = {

    # windows10-22h2-x64-pro = {
    #   vb_guest_os_type     = "Windows10_64"
    #   vmware_guest_os_type = "windows9-64"
    #   iso_url              = "./en-us_windows_10_consumer_editions_version_22h2_x64_dvd_8da72ab3.iso"
    #   iso_checksum         = "sha256:f41ba37aa02dcb552dc61cef5c644e55b5d35a8ebdfac346e70f80321343b506"
    #   autounattend        = {
    #     image_name              = "Windows 10 Pro"
    #     administrator_password  = "${local.administrator_password}"
    #     user                    = "${local.user}"
    #     user_password           = "${local.user_password}"
    #     user_data_key           = "<Key />"
    #   }
    # }

    windows10-22h2-x64 = {
      vb_guest_os_type     = "Windows10_64"
      vmware_guest_os_type = "windows9-64"
      iso_url              = "https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
      iso_checksum         = "sha256:ef7312733a9f5d7d51cfa04ac497671995674ca5e1058d5164d6028f0938d668"
      autounattend        = {
        image_name              = "Windows 10 Enterprise Evaluation"
        administrator_password  = "${local.administrator_password}"
        user                    = "${local.user}"
        user_password           = "${local.user_password}"
        user_data_key           = ""
      }
    }

    windows11-22h2-x64 = {
      vb_guest_os_type     = "Windows11_64"
      vmware_guest_os_type = "windows11-64"
      iso_url              = "https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66751/22621.525.220925-0207.ni_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
      iso_checksum         = "sha256:ebbc79106715f44f5020f77bd90721b17c5a877cbc15a3535b99155493a1bb3f"
      autounattend        = {
        image_name              = "Windows 11 Enterprise Evaluation"
        administrator_password  = "${local.administrator_password}"
        user                    = "${local.user}"
        user_password           = "${local.user_password}"
        user_data_key           = ""
      }
    }

    windows-2022-standard = {
      vb_guest_os_type     = "Windows2019_64"
      vmware_guest_os_type = "windows9srv-64"
      iso_url              = "https://software-static.download.prss.microsoft.com/sg/download/888969d5-f34g-4e03-ac9d-1f9786c66749/SERVER_EVAL_x64FRE_en-us.iso"
      iso_checksum         = "sha256:3e4fa6d8507b554856fc9ca6079cc402df11a8b79344871669f0251535255325"
      autounattend      = {
        image_name              = "Windows Server 2022 SERVERSTANDARD"
        administrator_password  = "${local.administrator_password}"
        user                    = "${local.user}"
        user_password           = "${local.user_password}"
        user_data_key           = ""
      }
    }

    windows-2022-standard-core = {
      vb_guest_os_type     = "Windows2019_64"
      vmware_guest_os_type = "windows9srv-64"
      iso_url              = "https://software-static.download.prss.microsoft.com/sg/download/888969d5-f34g-4e03-ac9d-1f9786c66749/SERVER_EVAL_x64FRE_en-us.iso"
      iso_checksum         = "sha256:3e4fa6d8507b554856fc9ca6079cc402df11a8b79344871669f0251535255325"
      user                 = "${local.user}"
      user_password        = "${local.user_password}"
      autounattend      = {
        image_name              = "Windows Server 2022 SERVERSTANDARDCORE"
        administrator_password  = "${local.administrator_password}"
        user                    = "${local.user}"
        user_password           = "${local.user_password}"
        user_data_key           = ""
      }
    }

  }

}

source "virtualbox-iso" "windows" {
  # keep_registered       = true
  # skip_export           = true 
  keep_registered       = false
  skip_export           = false 
  headless              = "${local.headless}"  
  guest_additions_mode  = "disable"
  cd_files              = ["scripts"]
  cpus                  = "${local.cpus}"
  memory                = "${local.memory}"
  disk_size             = "${local.disk_size}"
  boot_wait             = "10s"
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
  net_device          = "virtio-net"  
  # disk_interface      = "virtio"
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
  shutdown_command               = "${local.shutdown_command}"
  shutdown_timeout               = "15m"
  winrm_timeout                  = "60m"
  winrm_insecure                 = true
  winrm_use_ssl                  = false
  winrm_password                 = "${local.administrator_password}"
  winrm_username                 = "Administrator"
  disable_vnc                    = true
  disk_type_id                   = 0
  version                        = 14
  network_adapter_type           = "e1000"
}

source "hyperv-iso" "windows" {
  communicator          = "winrm"
  cd_files              = ["scripts"]
  cpus                  = "${local.cpus}"
  disk_size             = "${local.disk_size}"
  enable_dynamic_memory = "true"
  guest_additions_mode  = "disable"
  memory                = "${local.memory}"
  shutdown_command      = "${local.shutdown_command}"
  shutdown_timeout      = "15m"
  winrm_insecure        = true
  winrm_use_ssl         = false
  winrm_password        = "${local.administrator_password}"
  winrm_timeout         = "60m"
  winrm_username        = "Administrator"
  # switch_name           = "packer-windows"
  enable_secure_boot    = false
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
      }
    }
  }

  dynamic "source" {
    for_each = local.builds
    labels   = ["source.hyperv-iso.windows"]
    content {
      name              = source.key
      vm_name           = source.key
      iso_url           = source.value.iso_url
      iso_checksum      = source.value.iso_checksum
      output_directory  = "output/hyperv_${source.key}"
      cd_content        = {
        "/autounattend.xml" = templatefile("${path.root}/unattend/autounattend.pkrtpl", source.value),
        "/unattend.xml"     = templatefile("${path.root}/unattend/unattend.pkrtpl", source.value),
      }
    }
  }

  # provisioner "powershell" {
  #   inline = ["Start-Sleep -Seconds 3600"]
  # }

  # provisioner "powershell" {
  #   script = "scripts/installSalt.ps1"
  # }

  # provisioner "powershell" {
  #   inline = ["salt-call --local state.highstate --file-root=E:\\salt\\states"]
  # }

  provisioner "file" {
    destination = "C:/scripts/ConfigureRemotingForAnsible.ps1"
    source      = "scripts/ConfigureRemotingForAnsible.ps1"
  }

  provisioner "ansible" {
    # command         = ".venvP312A216/bin/ansible-playbook"
    playbook_file    = "ansible/windows/main.yml"
    use_proxy        = false
    user             = "Administrator"
    extra_arguments  = [ "-e", "winrm_password=${build.Password}" ]
    # ansible_env_vars = [
    #   "ANSIBLE_CONFIG=ansible/ansible.cfg",
    # ]
  }

  # provisioner "shell-local"{
  #   environment_vars = [
  #     "ANSIBLE_HOST=${build.Host}",
  #     "ANSIBLE_PORT=${build.Port}",
  #     "ANSIBLE_USER=${build.User}",
  #     "ANSIBLE_PASSWORD=${build.Password}"
  #   ]
  #   inline           = [
  #     "ansible-playbook -i \"$ANSIBLE_HOST,\" --extra-vars=\"ansible_user=$ANSIBLE_USER ansible_password=$ANSIBLE_PASSWORD ansible_port=$ANSIBLE_PORT\" ansible/windows/main.yml"
  #   ]
  # }

  # # for Debian WSL
  # provisioner "shell-local"{
  #   inline =[
  #     "apt update",
  #     "apt install -y ansible python3 python3-pip",
  #     "python3 -m pip install pywinrm"
  #   ]
  #   only   = [
  #     "hyperv-iso.windows10-22h2-x64",
  #     "hyperv-iso.windows11-22h2-x64"
  #     "hyperv-iso.windows-2022-standard",
  #     "hyperv-iso.windows-2022-standard-core"
  #   ]
  # }

  # Set-ExecutionPolicy -ExecutionPolicy Bypass

  # provisioner "shell-local"{
  #   environment_vars = [
  #     "ANSIBLE_HOST=${build.Host}",
  #     "ANSIBLE_PORT=${build.Port}",
  #     "ANSIBLE_USER=${build.User}",
  #     "ANSIBLE_PASSWORD=${build.Password}"
  #   ]
  #   tempfile_extension = ".ps1"
  #   execute_command    = ["powershell.exe", "{{.Vars}} {{.Script}}"]
  #   env_var_format     = "$env:%s=\"%s\"; "
  #   inline             = [
  #     "wsl -e ansible-playbook --extra-vars=\"ansible_user=$Env:ANSIBLE_USER ansible_password=$Env:ANSIBLE_PASSWORD ansible_port=$Env:ANSIBLE_PORT\" -i \"$Env:ANSIBLE_HOST,\"  ansible/windows/main.yml"
  #   ]
  #   only   = [
  #     "hyperv-iso.windows10-22h2-x64",
  #     "hyperv-iso.windows11-22h2-x64",
  #     "hyperv-iso.windows-2022-standard",
  #     "hyperv-iso.windows-2022-standard-core"
  #   ]
  # }

  provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
    restart_timeout       = "15m"
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

    post-processor "shell-local" {
      inline = ["vagrant box add --force ${source.name} ${source.name}-${source.type}.box"]
    }

    post-processor "shell-local" {
      inline = [ 
        "bash -c \"if [[ $PACKER_BUILDER_TYPE == 'qemu' ]]; then vagrant up ${source.name} --provider=libvirt ; fi\"",
        "bash -c \"if [[ $PACKER_BUILDER_TYPE == 'virtualbox-iso' ]]; then vagrant up ${source.name} --provider=virtualbox ; fi\"",
        "bash -c \"if [[ $PACKER_BUILDER_TYPE == 'vmware-iso' ]]; then vagrant up ${source.name} --provider=vmware_desktop ; fi\""
      ]
      except = [
        "hyperv-iso.windows10-22h2-x64",
        "hyperv-iso.windows11-22h2-x64",
        "hyperv-iso.windows-2022-standard",
        "hyperv-iso.windows-2022-standard-core"
      ]
    }

    post-processor "shell-local" {
      inline = ["vagrant destroy -f"]
    }

    # post-processor "vagrant-cloud" {
    #   access_token        = "${var.cloud_token}"
    #   box_tag             = "valengus/${source.name}"
    #   version             = "1.0.${local.packerstarttime}"
    #   no_release          = true
    #   version_description = templatefile("${path.root}/vagrant/${source.name}/version_description.md", { 
    #     date = formatdate("DD.MM.YYYY", timestamp())
    #   } )
    # }

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
      no_release          = false
    }

  }

}