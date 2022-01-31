

data "aws_iam_policy_document" "velero_assume" {

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.iam_role_nodes]
    }
  }
}

resource "aws_iam_role" "velero" {
  count              = var.eks ? 0 : 1
  name               = "velero.${var.cluster_domain_name}"
  assume_role_policy = data.aws_iam_policy_document.velero_assume.json
}

data "aws_iam_policy_document" "velero" {

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

resource "aws_iam_role_policy" "velero" {
  count  = var.eks ? 0 : 1
  name   = "velero"
  role   = aws_iam_role.velero.0.id
  policy = data.aws_iam_policy_document.velero.json
}

