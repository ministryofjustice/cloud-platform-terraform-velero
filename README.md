# cloud-platform-terraform-velero

[![Releases](https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-template/all.svg?style=flat-square)](https://github.com/ministryofjustice/cloud-platform-terraform-template/releases)

Terraform module that deploy cloud-platform velero which manages the backup and restore of all resources of the cluster

## Usage

```hcl
module "velero" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-velero?ref=0.0.1"
  iam_role_nodes                             = data.aws_iam_role.nodes.arn
  cluster_domain_name = data.terraform_remote_state.cluster.outputs.cluster_domain_name
  # This module requires Prometheus operator already deployed
  dependence_prometheus    = module.prometheus.helm_prometheus_operator_status
  # The below variables are for EKS
  eks                         = true
  eks_cluster_oidc_issuer_url = data.terraform_remote_state.cluster.outputs.cluster_oidc_issuer_url
}

```
## Inputs

_Describe what to pass the module_
_example_:

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| iam_role_nodes               | Nodes IAM role ARN in order to create the KIAM/Kube2IAM | string | | yes |
| dependence_prometheus               |  Prometheus Dependence variable  | string | | yes |
| cluster_domain_name         | Value used for velero IAM role names                | string   |         | yes |
| eks                         | Are we deploying in EKS or not?                                        | bool     | false   | no |
| eks_cluster_oidc_issuer_url | The OIDC issuer URL from the cluster, it is used for IAM ServiceAccount integration | string     |  | no |

## Reading Material

Click [here](https://velero.io/docs/v1.2.0/) for the official Velero documentation. 
[Runbook](https://runbooks.cloud-platform.service.justice.gov.uk/velero.html#velero-cluster-backups-and-disaster-recovery
) on instructions and setup on cloud-platform clusters.