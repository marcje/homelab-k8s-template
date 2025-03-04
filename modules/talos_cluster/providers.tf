terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.8.2"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.7.1"
    }
  }
}

provider "libvirt" {
  uri = "qemu+ssh://marc@192.168.1.7/system"
}

