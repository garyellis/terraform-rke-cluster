variable "cluster_name" {
  description = "The kubernetes cluster name"
  type        = string
}

variable "network_plugin" {
  description = "The kubernetes cluster cni"
  type        = string
  default     = "canal"
}

variable "apiserver_sans" {
  description = "A list of sans associated to the apiserver"
  type        = list(string)
  default     = []
}

variable "private_registries" {
  description = "a list of private registries"
  type        = list(map(string))
  default     = []
}

variable "cloud_provider" {
  description = "the cloud provider config"
  type        = map(string)
  default = {
    name = "aws"
  }
}

variable "ssh_user" {
  description = "The ssh user"
  type        = string
}

variable "ssh_key_path" {
  description = "The ssh key path"
  type        = string
  default     = null
}

variable "ssh_cert_path" {
  description = "the ssh cert path"
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels applied to all nodes"
  type        = map(string)
  default     = {}
}

variable "etcd_node_addresses" {
  description = "A list of etcd node ip address or dns name"
  type        = list(string)
  default     = []
}

variable "etcd_node_internal_addresses" {
  description = "A list of etcd node ip address or dns name"
  type        = list(string)
  default     = []
}

variable "controlplane_node_addresses" {
  description = "A list of controlplane node ip address or dns name"
  type        = list(string)
  default     = []
}

variable "controlplane_node_internal_addresses" {
  description = "A list of controlplane node ip address or dns name"
  type        = list(string)
  default     = []
}

variable "etcd_controlplane_node_addresses" {
  description = "A list of controlplane node ip address or dns name"
  type        = list(string)
  default     = []
}

variable "etcd_controlplane_node_internal_addresses" {
  description = "A list of controlplane node ip address or dns name"
  type        = list(string)
  default     = []
}

variable "etcd_controlplane_worker_node_addresses" {
  description = "A list of controlplane node ip address or dns name"
  type        = list(string)
  default     = []
}

variable "etcd_controlplane_worker_node_internal_addresses" {
  description = "A list of controlplane node ip address or dns name"
  type        = list(string)
  default     = []
}

variable "worker_node_addresses" {
  description = "A list of worker node ip address or dns name"
  type        = list(string)
  default     = []
}

variable "worker_node_internal_addresses" {
  description = "A list of worker node ip address or dns name"
  type        = list(string)
  default     = []
}
