variable "talos_install_iso" {
  type        = string
  description = "Absolute path to the installation ISO of talos"
  default     = "/internal-storage/hdd1/media/software/operating_systems/metal-amd64.iso"
}

variable "talos_domain" {
  type        = string
  description = "Which domain to configure the cluster in"
}

variable "talos_cluster_name" {
  type        = string
  description = "Name of the cluster"
}

variable "talos_cluster_index" {
  type        = number
  description = "Incremented index number to distinct clusters"
}

# TODO: Might use this again when IP management has been implemented in homelab
#variable "talos_cluster_subnet_cidr" {
#  type        = string
#  description = "The subnet to be used for the cluster"
#}
#variable "talos_controller_count" {
#  type        = number
#  description = "Amount of controller nodes to deploy"
#  default     = 3
#}

# TODO: Replace when IP management has been implemented in homelab
variable "talos_cluster_start_ip" {
  type        = string
  description = "The first IP address to be used in the cluster for simplicity and predictability"
}

variable "talos_worker_count" {
  type        = number
  description = "Amount of worker nodes to deploy"
  default     = 2
}

variable "talos_controller_cpus" {
  type        = number
  description = "Amount of CPU's for each controller node"
  default     = 2
}

variable "talos_controller_memory" {
  type        = number
  description = "Amount of RAM for each controller node in GB"
  default     = 4
}

variable "talos_worker_cpus" {
  type        = number
  description = "Amount of CPU's for each worker node"
  default     = 4
}

variable "talos_worker_memory" {
  type        = number
  description = "Amount of RAM for each worker node in GB"
  default     = 8
}

variable "talos_os_disk_size" {
  type        = number
  description = "Size of the OS disk in GB"
  default     = 20
}

variable "talos_data_disk_size" {
  type        = number
  description = "Size of the data disk on worker nodes for shared persistent storage in GB"
  default     = 20
}
