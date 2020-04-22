# terraform-rke-cluster
Create a Kubernetes on existing nodes. This terraform module provides the following functionality:

* kubernetes cluster creation
* support for airgap environments


## Requirements

* Terraform v0.12
* terraform-provider-rke v1.0.x
* RKE v1.1.x
* ssh connectivity to kubernetes cluster nodes



## Providers

| Name | Version |
|------|---------|
| local | n/a |
| rke | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| apiserver\_sans | A list of sans associated to the apiserver | `list(string)` | `[]` | no |
| cluster\_name | The kubernetes cluster name | `string` | n/a | yes |
| controlplane\_node\_addresses | A list of controlplane node ip address or dns name | `list(string)` | `[]` | no |
| default\_registry | override the rke system images default registry | `string` | `""` | no |
| etcd\_node\_addresses | A list of etcd node ip address or dns name | `list(string)` | `[]` | no |
| ssh\_key\_path | The ssh key path | `string` | `` | yes |
| ssh\_user | The ssh user | `string` | `` | yes |
| worker\_node\_addresses | A list of worker node ip address or dns name | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| api\_server\_url | n/a |
| ca\_crt | n/a |
| client\_cert | n/a |
| client\_key | n/a |
| kube\_cluster\_yaml | n/a |

