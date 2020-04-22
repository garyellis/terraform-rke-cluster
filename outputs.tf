output "api_server_url" {
  value = rke_cluster.cluster.api_server_url
}

output "client_cert" {
  value = rke_cluster.cluster.client_cert
}

output "client_key" {
  value = rke_cluster.cluster.client_key
  sensitive = true
}

output "ca_crt" {
  value = rke_cluster.cluster.ca_crt
}

output "kube_cluster_yaml" {
  value = "./kube_config_cluster.yml"
}
