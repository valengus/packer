packer {
  required_plugins {
    windows-update = {
      version = "0.17.2"
      source  = "github.com/rgl/windows-update"
    }
  }
}

locals {
  packerstarttime         = formatdate("YYYYMMDD", timestamp())
  administrator_password  = "password"
  product_key             = "<Key>VK7JG-NPHTM-C97JM-9MPGT-3V66T</Key>"
  os_image_name           = "Windows 11 Professional"
  iso_url                 = "${path.root}/iso/Win11_25H2_English_x64.iso"
  iso_checksum            = "sha256:d141f6030fed50f75e2b03e1eb2e53646c4b21e5386047cb860af5223f102a32"
}

source "virtualbox-iso" "windows-11-25h2-audit-mode" {
  vm_name              = "${source.name}"
  guest_os_type        = "Windows11_64"
  guest_additions_mode = "disable"
  # keep_registered      = true
  # skip_export          = true
  headless             = false
  iso_url              = "${path.root}/iso/Win11_25H2_English_x64.iso"
  iso_checksum         = "sha256:d141f6030fed50f75e2b03e1eb2e53646c4b21e5386047cb860af5223f102a32"
  cpus                 = 4
  memory               = 8 * 1024
  disk_size            = 60 * 1024
  cd_files             = [ "unattend/*", "scripts" ]
  boot_wait            = "5s"
  communicator         = "winrm"
  winrm_timeout        = "60m"
  winrm_insecure       = true
  winrm_use_ssl        = false
  winrm_username       = "Administrator"
  winrm_password       = "password"
  shutdown_command     = "shutdown /s /t 10 /f"
  # shutdown_command     = "E:\\scripts\\packerShutdown.bat"
}

build {
  sources = ["source.virtualbox-iso.windows-11-25h2-audit-mode"]

  provisioner "powershell" {
    inline = [ 
      "choco install virtualbox-guest-additions-guest.install -y", 
      "choco install sysinternals -y",
      "choco install sdelete -y"
    ]
  }

  provisioner "powershell" {
    inline = [
      "psexec -s -i powershell.exe -ExecutionPolicy Bypass -File 'E:\\scripts\\installUpdates.ps1'"
    ]
  }

  provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'Restarted.'}\""
    restart_timeout       = "15m"
    check_registry        = true
  }

  provisioner "powershell" {
    inline = [
      "psexec -s -i powershell.exe -ExecutionPolicy Bypass -File 'E:\\scripts\\cleanUp.ps1'"
    ]
  }

  provisioner "powershell" {
    inline = [
      "Optimize-Volume -DriveLetter C -Defrag -Verbose",
      "sdelete -z C:"
    ]
  }

  post-processors {
    post-processor "vagrant" {
      compression_level    = 9
      output               = "${source.type}-${source.name}.box"
      vagrantfile_template = "Vagrantfile.template"
    }
  }

}
