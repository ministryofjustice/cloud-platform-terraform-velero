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
  depends_on = [module.prometheus.helm_prometheus_operator_status]
  eks_cluster_oidc_issuer_url = data.terraform_remote_state.cluster.outputs.cluster_oidc_issuer_url
}

```

## Reading Material

Click [here](https://velero.io/docs/v1.2.0/) for the official Velero documentation. 
[Runbook](https://runbooks.cloud-platform.service.justice.gov.uk/velero.html#velero-cluster-backups-and-disaster-recovery
) on instructions and setup on cloud-platform clusters.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=4.24.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >=2.6.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >=2.12.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=4.24.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >=2.6.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >=2.12.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_assumable_role_admin"></a> [iam\_assumable\_role\_admin](#module\_iam\_assumable\_role\_admin) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 5.52.2 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.velero](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [helm_release.velero](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.velero](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [aws_iam_policy_document.velero_irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_domain_name"></a> [cluster\_domain\_name](#input\_cluster\_domain\_name) | The cluster domain used for iam\_assumable\_role\_admin role name | `any` | n/a | yes |
| <a name="input_eks_cluster_oidc_issuer_url"></a> [eks\_cluster\_oidc\_issuer\_url](#input\_eks\_cluster\_oidc\_issuer\_url) | This is going to be used when we create the IAM OIDC role | `string` | `""` | no |
| <a name="input_enable_velero"></a> [enable\_velero](#input\_enable\_velero) | Enable or not velero Helm Chart | `bool` | `true` | no |
| <a name="input_node_agent_cpu_requests"></a> [node\_agent\_cpu\_requests](#input\_node\_agent\_cpu\_requests) | CPU requests for node-agent | `string` | `"500m"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
