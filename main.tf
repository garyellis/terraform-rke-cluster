locals {
  etcd_node_internal_addresses = length(var.etcd_node_internal_addresses) == 0 ? var.etcd_node_addresses : var.etcd_node_internal_addresses
  etcd_nodes = [
    for i, address in compact(concat(var.etcd_node_addresses)) : {
      address          = address
      internal_address = local.etcd_node_internal_addresses[i]
      user             = var.ssh_user
      role             = ["etcd"]
      labels           = var.labels
      ssh_key_path     = var.ssh_key_path
      ssh_cert_path    = var.ssh_cert_path
    }
  ]

  controlplane_node_internal_addresses = length(var.controlplane_node_internal_addresses) == 0 ? var.controlplane_node_addresses : var.controlplane_node_internal_addresses
  controlplane_nodes = [
    for i, address in compact(concat(var.controlplane_node_addresses)) : {
      address          = address
      internal_address = local.controlplane_node_internal_addresses[i]
      user             = var.ssh_user
      role             = ["controlplane"]
      labels           = var.labels
      ssh_key_path     = var.ssh_key_path
      ssh_cert_path    = var.ssh_cert_path
    }
  ]

  worker_node_internal_addresses = length(var.worker_node_internal_addresses) == 0 ? var.worker_node_addresses : var.worker_node_internal_addresses
  worker_nodes = [
    for i, address in compact(concat(var.worker_node_addresses)) : {
      address          = address
      internal_address = var.worker_node_internal_addresses[i]
      user             = var.ssh_user
      role             = ["worker"]
      labels           = var.labels
      ssh_key_path     = var.ssh_key_path
      ssh_cert_path    = var.ssh_cert_path
    }
  ]

  etcd_controlplane_node_internal_addresses = length(var.etcd_controlplane_node_internal_addresses) == 0 ? var.etcd_controlplane_node_addresses : var.etcd_controlplane_node_internal_addresses
  etcd_controlplane_nodes = [
    for i, address in compact(concat(var.etcd_controlplane_node_addresses)) : {
      address          = address
      internal_address = local.etcd_controlplane_node_internal_addresses[i]
      user             = var.ssh_user
      role             = ["etcd", "controlplane"]
      labels           = var.labels
      ssh_key_path     = var.ssh_key_path
      ssh_cert_path    = var.ssh_cert_path
    }
  ]

  etcd_controlplane_worker_node_internal_addresses = length(var.etcd_controlplane_worker_node_internal_addresses) == 0 ? var.etcd_controlplane_worker_node_addresses : var.etcd_controlplane_worker_node_internal_addresses
  etcd_controlplane_worker_nodes = [
    for i, address in compact(concat(var.etcd_controlplane_worker_node_addresses)) : {
      address          = address
      internal_address = local.etcd_controlplane_worker_node_internal_addresses[i]
      user             = var.ssh_user
      role             = ["etcd", "controlplane", "worker"]
      labels           = var.labels
      ssh_key_path     = var.ssh_key_path
      ssh_cert_path    = var.ssh_cert_path
    }
  ]

  all_nodes = concat(local.etcd_nodes, local.controlplane_nodes, local.etcd_controlplane_nodes, local.etcd_controlplane_worker_nodes, local.worker_nodes)
}

resource "rke_cluster" "cluster" {
  cluster_name = var.cluster_name

  dynamic "private_registries" {
    for_each = var.private_registries
    content {
      url        = lookup(private_registries.value, "url")
      is_default = lookup(private_registries.value, "is_default", null)
      password   = lookup(private_registries.value, "password", null)
      user       = lookup(private_registries.value, "user", null)
    }
  }

  authentication {
    strategy = "x509"
    sans     = var.apiserver_sans
  }
  services {
    etcd {}
    kube_api {
      audit_log {
        enabled = "true"
      }
    }
    kube_controller {}
    scheduler {}
    kubelet {}
    kubeproxy {}
  }
  upgrade_strategy {
    drain = false
  }

  network {
    plugin = var.network_plugin
  }

  ingress {
    provider = "nginx"
  }

  dynamic "cloud_provider" {
    for_each = length(var.cloud_provider) > 0 ? [1] : []
    content {
      name = lookup(var.cloud_provider, "name")
    }
  }

  dynamic "nodes" {
    for_each = local.all_nodes
    content {
      address          = lookup(nodes.value, "address")
      internal_address = lookup(nodes.value, "internal_address")
      user             = lookup(nodes.value, "user")
      role             = lookup(nodes.value, "role")
      labels           = lookup(nodes.value, "labels")
      ssh_key_path     = lookup(nodes.value, "ssh_key_path", null)
      ssh_cert_path    = lookup(nodes.value, "ssh_cert_path", null)
    }
  }
}

resource "local_file" "kube_cluster_yaml" {
  filename = "./kube_config_cluster.yml"
  content  = rke_cluster.cluster.kube_config_yaml
}
