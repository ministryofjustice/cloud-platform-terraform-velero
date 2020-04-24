
variable "iam_role_nodes" {
  description = "Nodes IAM role ARN in order to create the KIAM/Kube2IAM"
  type        = string
}

variable "dependence_prometheus" {
  description = "Prometheus module - Prometheus Operator dependences in order to be executed."
}
