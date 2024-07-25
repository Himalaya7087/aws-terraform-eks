terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9"
    }
  }

  backend "s3" {
    bucket  = var.bucket
    key     = var.key
    region  = var.region
    encrypt = true
  }
}

provider "aws" {
  region                   = "ap-south-1"
  shared_credentials_files = ["/Users/admin/.aws/credentials"]
}

# provider "http" {
# }

data "aws_eks_cluster" "eks_cluster" {
  name = aws_eks_cluster.eks_cluster.name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode("${data.aws_eks_cluster.eks_cluster.certificate_authority[0].data}")
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", "${data.aws_eks_cluster.eks_cluster.id}"]
      command     = "aws"
    }
  }
}


