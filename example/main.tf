module "velero" {
  source = "../"

  iam_role_nodes              = "arn:aws:iam::0123456789:role/dummy"
  cluster_domain_name         = "dummy"
  dependence_prometheus       = "dummy"
  eks                         = true
  eks_cluster_oidc_issuer_url = "oidc.eks.eu-west-2.amazonaws.com/id/dummy"
}
