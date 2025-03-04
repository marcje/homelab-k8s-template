module "talos_cluster" {
  source            = "./modules/talos_cluster"
  talos_install_iso = var.talos_install_iso
  domain            = var.talos_domain
  cluster_name      = var.talos_cluster_name
  cluster_index     = var.talos_cluster_index
  cluster_start_ip  = var.talos_cluster_start_ip
  os_disk_size      = var.talos_os_disk_size
  data_disk_size    = var.talos_data_disk_size
  controller_cpus   = var.talos_controller_cpus
  controller_memory = var.talos_controller_memory
  worker_count      = var.talos_worker_count
  worker_cpus       = var.talos_worker_cpus
  worker_memory     = var.talos_worker_memory
}
