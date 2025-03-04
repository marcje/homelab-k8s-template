variable "talos_install_iso" {
  type        = string
  description = "Absolute path to the installation ISO of talos"
}

variable "domain" {
  type        = string
  description = "In which domain to configure the cluster"
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}

variable "cluster_index" {
  type        = number
  description = "Incremented index number to distinct clusters"
}

# TODO: Use when IP management has been implemented in homelab
#variable "cluster_subnet_cidr" {
#  type        = string
#  description = "The subnet to be used for the cluster"
#}
#variable "controller_count" {
#  type        = number
#  description = "How many controller nodes to deploy"
#}

# TODO: Replace when IP management has been implemented in homelab
variable "cluster_start_ip" {
  type        = string
  description = "The first IP address to be used in the cluster for simplicity and predictability"
}

variable "controller_cpus" {
  type        = number
  description = "Amount of CPU's for each controller node"
}

variable "controller_memory" {
  type        = number
  description = "Amount of RAM for each controller node in GB"
}

variable "worker_count" {
  type        = number
  description = "How many worker nodes to deploy"
}

variable "worker_cpus" {
  type        = number
  description = "Amount of CPU's for each worker node"
}

variable "worker_memory" {
  type        = number
  description = "Amount of RAM for each worker node in GB"
}

variable "os_disk_size" {
  type        = number
  description = "Size of the OS disk in GB"
}

variable "data_disk_size" {
  type        = number
  description = "Size of the data disk on worker nodes for shared persistent storage in GB"
}

