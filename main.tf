resource "kubernetes_namespace" "velero" {
  count = var.enable_velero ? 1 : 0
  metadata {
    name = "velero"

    labels = {
      "component"                                      = "velero"
      "cloud-platform.justice.gov.uk/environment-name" = "production"
      "cloud-platform.justice.gov.uk/is-production"    = "true"
    }

    annotations = {
      "cloud-platform.justice.gov.uk/application"   = "Velero"
      "cloud-platform.justice.gov.uk/business-unit" = "Platforms"
      "cloud-platform.justice.gov.uk/owner"         = "Cloud Platform: platforms@digital.justice.gov.uk"
      "cloud-platform.justice.gov.uk/source-code"   = "https://github.com/ministryofjustice/cloud-platform-infrastructure"
      "cloud-platform-out-of-hours-alert"           = "true"
    }
  }
}

resource "helm_release" "velero" {
  count      = var.enable_velero ? 1 : 0
  name       = "velero"
  namespace  = kubernetes_namespace.velero[count.index].id
  repository = "https://vmware-tanzu.github.io/helm-charts"
  chart      = "velero"
  version    = "5.0.2"

  depends_on = [
    kubernetes_namespace.velero,
    var.dependence_prometheus,
  ]
  values = [templatefile("${path.module}/templates/velero.yaml.tpl", {
    cluster_name        = terraform.workspace
    eks_service_account = module.iam_assumable_role_admin.this_iam_role_arn
    node_agent_cpu_requests = var.node_agent_cpu_requests
  })]

  lifecycle {
    ignore_changes = [keyring]
  }
}
