
variable "dependence_prometheus" {
  description = "Prometheus module - Prometheus Operator dependences in order to be executed."
}

variable "cluster_domain_name" {
  description = "The cluster domain used for iam_assumable_role_admin role name"
}

variable "eks_cluster_oidc_issuer_url" {
  description = "This is going to be used when we create the IAM OIDC role"
  type        = string
  default     = ""
}

variable "enable_velero" {
  description = "Enable or not velero Helm Chart"
  default     = true
  type        = bool
}

variable "restic_cpu_requests" {
  description = "CPU requests for restic"
  default     = "500m"   # 500m is the Velero Helm defined default for Restic CPU requests
  type        = string
}