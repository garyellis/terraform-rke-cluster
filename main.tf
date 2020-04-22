locals {

  private_registries = [
    {
      url        = var.default_registry
      is_default = true
    }
  ]

  system_images = {
    etcd                        = ""
    alpine                      = ""
    nginx_proxy                 = ""
    cert_downloader             = ""
    kubernetes                  = ""
    kubernetes_services_sidecar = ""
    pod_infra_container         = ""

    kubedns            = ""
    dnsmasq            = ""
    kubedns_sidecar    = ""
    kubedns_autoscaler = ""

    coredns            = ""
    coredns_autoscaler = ""

    flannel     = ""
    flannel_cni = ""

    calico_node        = ""
    calico_cni         = ""
    calico_controllers = ""
    calico_ctl         = ""

    canal_node    = ""
    canal_cni     = ""
    canal_flannel = ""

    weave_node = ""
    weave_cni  = ""

    ingress         = ""
    ingress_backend = ""

    metrics_server = ""
  }


  etcd_nodes = [
    for i, private_ip in compact(concat(var.etcd_node_addresses)) : {
      address          = private_ip
      internal_address = private_ip
      user             = var.ssh_user
      role             = "etcd"
      ssh_key_path     = var.ssh_key_path
    }
  ]

  controlplane_nodes = [
    for i, private_ip in compact(concat(var.controlplane_node_addresses)) : {
      address          = private_ip
      internal_address = private_ip
      user             = var.ssh_user
      role             = "controlplane"
      ssh_key_path     = var.ssh_key_path
    }
  ]

  worker_nodes = [
    for i, private_ip in compact(concat(var.worker_node_addresses)) : {
      address          = private_ip
      internal_address = private_ip
      user             = var.ssh_user
      role             = "worker"
      ssh_key_path     = var.ssh_key_path
    }
  ]

  all_nodes = concat(local.etcd_nodes, local.controlplane_nodes, local.worker_nodes)
}

resource "rke_cluster" "cluster" {
  cluster_name = var.cluster_name

  authentication {
    strategy = "x509"
    sans     = var.apiserver_sans
  }
  services {
    etcd {}
    kube_api {}
    kube_controller {}
    scheduler {}
    kubelet {}
    kubeproxy {}
  }
  upgrade_strategy {
    drain = false
  }

  network {
    plugin = "canal"
  }

  ingress {
    provider = "nginx"
  }

  dynamic "nodes" {
    for_each = local.all_nodes
    content {
      address          = lookup(nodes.value, "address")
      internal_address = lookup(nodes.value, "internal_address")
      user             = lookup(nodes.value, "user")
      role             = split(",", lookup(nodes.value, "role"))
      ssh_key_path     = lookup(nodes.value, "ssh_key_path", null)
    }
  }
}

resource "local_file" "kube_cluster_yaml" {
  filename = "./kube_config_cluster.yml"
  content  = rke_cluster.cluster.kube_config_yaml
}
