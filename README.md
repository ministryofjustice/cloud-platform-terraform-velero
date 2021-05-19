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

<!--- END_TF_DOCS --->

## Reading Material

Click [here](https://velero.io/docs/v1.2.0/) for the official Velero documentation. 
[Runbook](https://runbooks.cloud-platform.service.justice.gov.uk/velero.html#velero-cluster-backups-and-disaster-recovery
) on instructions and setup on cloud-platform clusters.
