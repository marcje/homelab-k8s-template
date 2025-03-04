# Output Talos & Kubernetes Configuration
output "talosconfig" {
  value     = data.talos_client_configuration.talos_config.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  sensitive = true
}
