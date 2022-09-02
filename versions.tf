terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.6.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}
