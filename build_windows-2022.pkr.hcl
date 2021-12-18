variable "iso_checksum" {
  type    = string
  default = "sha256:4f1457c4fe14ce48c9b2324924f33ca4f0470475e6da851b39ccbf98f44e7852"
}

variable "iso_url" {
  type    = string
  default = "https://software-download.microsoft.com/download/sg/20348.169.210806-2348.fe_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"
}

locals {
  packerstarttime = formatdate("YYYYMMDD", timestamp())
  name            = "windows-2022"
  winrm_username  = "Administrator"
  winrm_password  = "password"

}

source "qemu" "windows-2022" {
  accelerator         = "kvm"
  cd_files            = ["unattend/windows-2022/autounattend.xml", "scripts/*", "drivers/qemu/*"]
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
  shutdown_command    = "E:/packerShutdown.bat"
  shutdown_timeout    = "15m"
  use_default_display = false
  vm_name             = "windows-2022_${local.packerstarttime}"
  winrm_insecure      = true
  winrm_use_ssl       = false
  winrm_password      = "${local.winrm_password}"
  winrm_username      = "${local.winrm_username}"
}


build {

  sources = [
    "source.qemu.windows-2022"
  ]

  provisioner "powershell" {
    inline = ["Start-Sleep -Seconds 60"]
  }

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

  provisioner "powershell" {

    inline = [
      "Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase",
      "Dism.exe /online /Cleanup-Image /SPSuperseded",
      "Get-WindowsFeature | ? { $_.InstallState -eq 'Available' } | Uninstall-WindowsFeature -Remove",
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
    destination = "C:/Windows/Temp/unattend.xml"
    source      = "unattend/unattend.xml"
  }

  # post-processors {
  #   post-processor "vagrant" {
  #     compression_level    = 9
  #     output               = "windows-2022-{{.Provider}}.box"
  #     vagrantfile_template = "vagrant/windows-2022.template"
  #   }
  # }

}