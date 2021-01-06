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
      "cloud-platform.justice.gov.uk/business-unit" = "Platforms"
      "cloud-platform.justice.gov.uk/owner"         = "Cloud Platform: platforms@digital.justice.gov.uk"
      "cloud-platform.justice.gov.uk/source-code"   = "https://github.com/ministryofjustice/cloud-platform-infrastructure"
      "iam.amazonaws.com/permitted"                 = var.eks ? "" : aws_iam_role.velero.0.name
      "cloud-platform-out-of-hours-alert"           = "true"
    }
  }
}

data "helm_repository" "vmware_tanzu" {
  name = "vmware-tanzu"
  url  = "https://vmware-tanzu.github.io/helm-charts"
}

resource "helm_release" "velero" {
  name       = "velero"
  namespace  = kubernetes_namespace.velero.id
  repository = data.helm_repository.vmware_tanzu.metadata[0].name
  chart      = "velero"
  version    = "2.14.4"

  depends_on = [
    kubernetes_namespace.velero,
    var.dependence_prometheus,
  ]
  values = [templatefile("${path.module}/templates/velero.yaml.tpl", {
    cluster_name        = terraform.workspace
    velero_iam_role     = var.eks ? "" : aws_iam_role.velero.0.name
    eks                 = var.eks
    eks_service_account = module.iam_assumable_role_admin.this_iam_role_arn
  })]

  lifecycle {
    ignore_changes = [keyring]
  }
}

resource "kubernetes_secret" "dockerhub_credentials" {
  count = var.eks ? 1 : 0

  metadata {
    name      = "dockerhub-credentials"
    namespace = kubernetes_namespace.velero.id
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = <<DOCKER
{
  "auths": {
    "https://index.docker.io/v1": {
      "auth": "${base64encode("${var.dockerhub_username}:${var.dockerhub_password}")}"
    }
  }
}
DOCKER
  }
}
