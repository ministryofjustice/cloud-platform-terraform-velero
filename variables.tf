
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

variable "node_agent_cpu_requests" {
  description = "CPU requests for node-agent"
  default     = "500m"   # 500m is the Velero Helm defined default for node-agent CPU requests
  type        = string
}
