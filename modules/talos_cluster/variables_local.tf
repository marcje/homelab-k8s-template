locals {
  # TODO: Hardcoded controller count for simplicity and predictability - change when IP management is available in homelab
  controller_count = 3

  ip_octets = split(".", var.cluster_start_ip)
  ip_base  = "${local.ip_octets[0]}.${local.ip_octets[1]}.${local.ip_octets[2]}"
  ip_host  = tonumber(local.ip_octets[3])

  mac_base = format("52:54:00")
  mac_cluster_id = format(":%02x", var.cluster_index)
  mac_controller_node_id = ":00"
  mac_worker_node_id = ":01"

  controllers = {
    # for i in range(var.controller_count) :
    for i in range(local.controller_count) :
    "${var.cluster_name}${var.cluster_index}-ctrl${i + 1}.${var.domain}" => {
      cpu            = var.controller_cpus
      memory         = var.controller_memory * 1024 # Convert GB to MB
      os_disk_size   = var.os_disk_size * 1024 * 1024 * 1024 # Convert GB to bytes
      data_disk_size = 0
      #ip_address     = var.controller_ips[i] # TODO: fetch from IP management
      ip_address     = "${local.ip_base}.${local.ip_host + i}"
      mac_address    = format("${local.mac_base}${local.mac_cluster_id}${local.mac_controller_node_id}:%02x", (i + 1))
    }
  }

  workers = {
    for i in range(var.worker_count) :
    "${var.cluster_name}${var.cluster_index}-wrk${i + 1}.${var.domain}" => {
      cpu            = var.worker_cpus
      memory         = var.worker_memory * 1024 # Convert GB to MB
      os_disk_size   = var.os_disk_size * 1024 * 1024 * 1024 # Convert GB to bytes
      data_disk_size = var.data_disk_size * 1024 * 1024 * 1024 # Convert GB to bytes
      #ip_address     = "${local.ip_base}.${local.ip_host + var.controller_count + i}"
      ip_address     = "${local.ip_base}.${local.ip_host + local.controller_count + i}"
      mac_address    = format("${local.mac_base}${local.mac_cluster_id}${local.mac_worker_node_id}:%02x", (i + 1))
    }
  }

  vm_instances = merge(local.controllers, local.workers)
}
