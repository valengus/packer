variable "cloud_token" {
  type    = string
  default = "${env("CLOUD_TOKEN")}"
}

variable "release_box" {
  type    = string
  default = "${env("RELEASE_BOX")}"
}

locals {
  packerstarttime     = formatdate("YYYYMMDD", timestamp())
  name                = "windows-2022"
  version_description = <<-EOF
  ### Windows Server 2022 SERVERSTANDARD box with :
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

source "null" "empty" {
  communicator = "none"
}

build {
  sources = ["source.null.empty"]

  post-processor "shell-local" {
    inline = ["echo Doing stuff..."]
  }

  post-processors {

    post-processor "artifice" {
      files = ["./${var.release_box}"]
    }

    post-processor "vagrant-cloud" {
      access_token        = "${var.cloud_token}"
      box_tag             = "valengus/${local.name}"
      version             = "1.0.${local.packerstarttime}"
      version_description = "${local.version_description}"
      no_release          = true
    }

  }

}