module "velero" {
  source = "../"

  cluster_domain_name         = "dummy"
  dependence_prometheus       = "dummy"
  eks_cluster_oidc_issuer_url = "oidc.eks.eu-west-2.amazonaws.com/id/dummy"
}
