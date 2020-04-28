resource "kubernetes_namespace" "velero" {
  metadata {
    name = "velero"

    labels = {
      "component"                                      = "velero"
      "cloud-platform.justice.gov.uk/environment-name" = "production"
      "cloud-platform.justice.gov.uk/is-production"    = "true"
    }

    annotations = {
      "cloud-platform.justice.gov.uk/application"   = "Velero"
      "cloud-platform.justice.gov.uk/business-unit" = "cloud-platform"
      "cloud-platform.justice.gov.uk/owner"         = "Cloud Platform: platforms@digital.justice.gov.uk"
      "cloud-platform.justice.gov.uk/source-code"   = "https://github.com/ministryofjustice/cloud-platform-infrastructure"
      "iam.amazonaws.com/permitted"                 = var.eks ? "" : aws_iam_role.velero.0.name
    }
  }
}

resource "helm_release" "velero" {
  name       = "velero"
  namespace  = kubernetes_namespace.velero.id
  repository = "vmware-tanzu"
  chart      = "velero"
    version    = "2.9.15"

  depends_on = [
    kubernetes_namespace.velero,
    var.dependence_prometheus,
  ]
  values = [templatefile("${path.module}/templates/velero.yaml.tpl", {
    cluster_name = terraform.workspace
    velero_iam_role     = var.eks ? "" : aws_iam_role.velero.0.name
    eks                 = var.eks
    eks_service_account = module.iam_assumable_role_admin.this_iam_role_arn
  })]

  lifecycle {
    ignore_changes = [keyring]
  }
}
