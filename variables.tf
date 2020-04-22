variable "cluster_name" {
  description = "The kubernetes cluster name"
  type        = string
}

variable "etcd_node_addresses" {
  description = "A list of etcd node ip address or dns name"
  type        = list(string)
  default     = []
}

variable "controlplane_node_addresses" {
  description = "A list of controlplane node ip address or dns name"
  type        = list(string)
  default     = []
}

variable "worker_node_addresses" {
  description = "A list of worker node ip address or dns name"
  type        = list(string)
  default     = []
}

variable "apiserver_sans" {
  description = "A list of sans associated to the apiserver"
  type        = list(string)
  default     = []
}

variable "ssh_user" {
  description = "The ssh user"
  type        = string
}

variable "ssh_key_path" {
  description = "The ssh key path"
  type        = string
}

variable "default_registry" {
  description = "override the rke system images default registry"
  type        = string
  default     = ""
}
