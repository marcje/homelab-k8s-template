resource "talos_machine_secrets" "machine_secrets" {}

locals {
  control_plane_ips = [for k, v in local.controllers : v.ip_address]
  worker_ips        = [for k, v in local.workers : v.ip_address]
  cluster_endpoint  = "https://${local.control_plane_ips[0]}:6443"
  cluster_name      = "${var.cluster_name}${var.cluster_index}"
}

data "talos_client_configuration" "talos_config" {
  cluster_name         = local.cluster_name
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  endpoints            = local.control_plane_ips
}

data "talos_machine_configuration" "ctrl_config" {
  cluster_name     = local.cluster_name
  cluster_endpoint = local.cluster_endpoint
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
}

resource "talos_machine_configuration_apply" "ctrl_config_apply" {
  for_each                    = local.controllers
  depends_on                  = [libvirt_domain.talos_cluster_vms]
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.ctrl_config.machine_configuration
  node                        = each.value.ip_address
  config_patches = [
    yamlencode({
      machine = {
        install = {
          disk = "/dev/vda"
        }
        network = {
          hostname = each.key
        }
      }
    })
  ]
}

data "talos_machine_configuration" "wrk_config" {
  cluster_name     = local.cluster_name
  cluster_endpoint = local.cluster_endpoint
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
}

resource "talos_machine_configuration_apply" "wrk_config_apply" {
  for_each                    = local.workers
  depends_on                  = [libvirt_domain.talos_cluster_vms]
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.wrk_config.machine_configuration
  node                        = each.value.ip_address
  config_patches = [
    yamlencode({
      machine = {
        install = {
          disk = "/dev/vda"
        }
        network = {
          hostname = each.key
        }
      }
    })
  ]
}

resource "talos_machine_bootstrap" "bootstrap" {
  depends_on           = [talos_machine_configuration_apply.ctrl_config_apply]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = local.control_plane_ips[0]
}

data "talos_cluster_health" "health" {
  depends_on           = [talos_machine_configuration_apply.ctrl_config_apply, talos_machine_configuration_apply.wrk_config_apply]
  client_configuration = data.talos_client_configuration.talos_config.client_configuration
  control_plane_nodes  = local.control_plane_ips
  worker_nodes         = local.worker_ips
  endpoints            = data.talos_client_configuration.talos_config.endpoints
}

# Fetch Kubernetes Kubeconfig from Talos
resource "talos_cluster_kubeconfig" "kubeconfig" {
  depends_on           = [talos_machine_bootstrap.bootstrap, data.talos_cluster_health.health]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = local.control_plane_ips[0]
}
