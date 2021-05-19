# cloud-platform-terraform-velero

[![Releases](https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-velero/all.svg?style=flat-square)](https://github.com/ministryofjustice/cloud-platform-terraform-velero/releases/tag/0.0.1)

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

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| helm | n/a |
| kubernetes | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| iam_assumable_role_admin | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 3.13.0 |

## Resources

| Name |
|------|
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_iam_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) |
| [helm_release](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) |
| [kubernetes_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_domain\_name | The cluster domain used for iam\_assumable\_role\_admin role name | `any` | n/a | yes |
| eks | Where are you applying this modules in kOps cluster or in EKS (KIAM or KUBE2IAM?) | `bool` | `false` | no |
| eks\_cluster\_oidc\_issuer\_url | If EKS variable is set to true this is going to be used when we create the IAM OIDC role | `string` | `""` | no |
| iam\_role\_nodes | Nodes IAM role ARN in order to create the KIAM/Kube2IAM | `string` | n/a | yes |

## Outputs

No output.

<!--- END_TF_DOCS --->

## Reading Material

Click [here](https://velero.io/docs/v1.2.0/) for the official Velero documentation. 
[Runbook](https://runbooks.cloud-platform.service.justice.gov.uk/velero.html#velero-cluster-backups-and-disaster-recovery
) on instructions and setup on cloud-platform clusters.
