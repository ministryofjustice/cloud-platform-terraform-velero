
# IAM Role for ServiceAccounts: This is for EKS

module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> v2.6.0"
  create_role                   = var.eks ? true : false
  role_name                     = "velero.${var.cluster_domain_name}"
  provider_url                  = var.eks_cluster_oidc_issuer_url
  role_policy_arns              = [var.eks && length(aws_iam_policy.velero) >= 1 ? aws_iam_policy.velero.0.arn : "" ]
  oidc_fully_qualified_subjects = ["system:serviceaccount:velero:velero-server"]
}

resource "aws_iam_policy" "velero" {
  count = var.eks ? 1 : 0

  name_prefix = "velero"
  description = "EKS velero policy for cluster ${var.cluster_domain_name}"
  policy      = data.aws_iam_policy_document.velero_irsa.json
}

data "aws_iam_policy_document" "velero_irsa" {

  statement {
    actions = [
      "sts:AssumeRole",
      "ec2:DescribeSnapshots",
      "ec2:DescribeVolumes",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot",
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
    ]
    resources = ["arn:aws:s3:::cloud-platform-velero-backups/*"]
  }
  statement {
    actions = [
      "s3:ListBucket",
    ]
    resources = ["arn:aws:s3:::cloud-platform-velero-backups"]
  }
}
