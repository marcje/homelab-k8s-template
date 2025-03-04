resource "libvirt_volume" "os_disks" {
  for_each = local.vm_instances

  name = "${each.key}.sda.qcow2"
  pool = "ssd1"
  size = each.value.os_disk_size
}

resource "libvirt_volume" "data_disks" {
  for_each = { for k, v in local.vm_instances : k => v if v.data_disk_size > 0 }

  name = "${each.key}.sdb.qcow2"
  pool = "ssd1"
  size = each.value.data_disk_size
}

resource "libvirt_domain" "talos_cluster_vms" {
  for_each = local.vm_instances

  name = each.key
  description = "Talos cluster VM ${each.key}"
  autostart = true
  running = true
  
  cpu {
    mode = "host-passthrough"
  }
  vcpu = each.value.cpu
  memory = each.value.memory

  # Installation ISO
  disk {
    file = var.talos_install_iso
  }

  disk {
    volume_id = libvirt_volume.os_disks[each.key].id
  }

  # Attach data disk only if it exists
  dynamic "disk" {
    for_each = each.value.data_disk_size > 0 ? [libvirt_volume.data_disks[each.key].id] : []
    content {
      volume_id = disk.value
    }
  }

  network_interface {
    bridge         = "br20"
    mac            = each.value.mac_address
  }
  
  boot_device {
    dev = [ "hd", "cdrom"]
  }
}
