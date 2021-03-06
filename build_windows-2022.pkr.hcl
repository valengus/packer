variable "iso_checksum" {
  type    = string
  default = "sha256:4f1457c4fe14ce48c9b2324924f33ca4f0470475e6da851b39ccbf98f44e7852"
}

variable "iso_url" {
  type    = string
  default = "https://software-download.microsoft.com/download/sg/20348.169.210806-2348.fe_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"
}

variable "cloud_token" {
  type    = string
  default = "${env("CLOUD_TOKEN")}"
}

locals {
  packerstarttime     = formatdate("YYYYMMDD", timestamp())
  name                = "windows-2022"
  winrm_username      = "Administrator"
  winrm_password      = "password"
  version_description = <<-EOF
  ### Windows Server 2022 STANDARD box with :
  source : [https://github.com/valengus/packer](https://github.com/valengus/packer)

  - chocolatey
  - drivers for kvm (viostor, netkvm, viorng, vioserial, qxldod, balloon)
  - qemu|virtualbox|vmware guest agent
  - winrm enabled over https
  - openssh

  ### Login Credentials

  Username: Administrator

  Password: password
  EOF
}

#### BUILD

source "qemu" "windows-2022" {
  accelerator         = "kvm"
  cd_files            = ["unattend/${local.name}/autounattend.xml", "scripts/*", "drivers/qemu/*"]
  communicator        = "winrm"
  cpus                = "2"
  memory              = "4096"
  disk_cache          = "writeback"
  disk_discard        = "ignore"
  disk_interface      = "virtio"
  disk_size           = "61440"
  format              = "qcow2"
  headless            = true
  vnc_bind_address    = "0.0.0.0"
  iso_checksum        = "${var.iso_checksum}"
  iso_url             = "${var.iso_url}"
  shutdown_command    = "C:\\Windows\\Temp\\packerShutdown.bat"
  shutdown_timeout    = "15m"
  use_default_display = false
  vm_name             = "${local.name}_${local.packerstarttime}"
  winrm_timeout       = "60m"
  winrm_insecure      = true
  winrm_use_ssl       = false
  winrm_password      = "${local.winrm_password}"
  winrm_username      = "${local.winrm_username}"
}

source "virtualbox-iso" "windows-2022" {
  headless             = true  
  boot_wait            = "10s"
  cd_files             = ["unattend/${local.name}/autounattend.xml", "scripts/*"]
  communicator         = "winrm"
  cpus                 = 2
  disk_size            = 61440
  format               = "ova"
  guest_additions_mode = "disable"
  guest_os_type        = "Windows2019_64"
  iso_checksum         = "${var.iso_checksum}"
  iso_url              = "${var.iso_url}"
  keep_registered      = false
  memory               = 4096
  post_shutdown_delay  = "15m"
  shutdown_command     = "C:\\Windows\\Temp\\packerShutdown.bat"
  skip_export          = false
  vm_name              = "${local.name}_${local.packerstarttime}"
  winrm_timeout        = "60m"
  winrm_insecure       = true
  winrm_use_ssl        = false
  winrm_password       = "${local.winrm_password}"
  winrm_username       = "${local.winrm_username}"
}


build {

  sources = [
    "source.qemu.windows-2022",
    "source.virtualbox-iso.windows-2022"
  ]

  provisioner "powershell" {
    inline = ["Start-Sleep -Seconds 120"]
  }

  # docker build --rm -t local/ansible:2.11.8 ansible

  provisioner "ansible" {
    playbook_file = "ansible/main.yml"
    use_proxy     = false
    user          = "${local.winrm_username}"
  }

  provisioner "powershell" {
    inline = ["Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"]
  }

  provisioner "powershell" {
    inline = ["choco install sdelete -y"]
  }

  // provisioner "powershell" {
  //   inline = [
  //     "Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase",
  //     "Dism.exe /online /Cleanup-Image /SPSuperseded",
  //     "Get-WindowsFeature | ? { $_.InstallState -eq 'Available' } | Uninstall-WindowsFeature -Remove",
  //   ]
  // }

  provisioner "powershell" {
    inline = [
      "Optimize-Volume -DriveLetter C -Defrag",
      "sdelete -z c:",
    ]
  }

  provisioner "powershell" {
    inline = ["Set-Service -Name sshd -StartupType Automatic"]
  }

  provisioner "file" {
    destination = "C:/scripts/ConfigureRemotingForAnsible.ps1"
    source      = "scripts/ConfigureRemotingForAnsible.ps1"
  }

  provisioner "file" {
    destination = "C:/Windows/Temp/packerShutdown.bat"
    source      = "scripts/packerShutdown.bat"
  }

  provisioner "file" {
    destination = "C:/Windows/Temp/unattend.xml"
    source      = "unattend/unattend.xml"
  }

  post-processors {

    post-processor "vagrant" {
      compression_level    = 9
      output               = "${local.name}-{{.Provider}}.box"
      vagrantfile_template = "vagrant/windows.template"
    }

  }

}

#### RELEASE

variable "release_box" {
  type    = string
  default = "${env("RELEASE_BOX")}"
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
      box_tag             = "valengus/${local.name}"
      # version             = "1.0.${local.packerstarttime}"
      version             = "1.0.20220116"
      version_description = "${local.version_description}"
      no_release          = true
    }

  }

}