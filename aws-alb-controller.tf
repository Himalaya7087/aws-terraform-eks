# Create IRSA for AWS Load Balancer Controller
module "load_balancer_controller_irsa_role" {
  source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                                = "5.41.0"
  role_name                              = "load-balancer-controller-eks-role"
  attach_load_balancer_controller_policy = true
  oidc_providers = {
    eks-cluster = {
      provider_arn               = aws_iam_openid_connect_provider.oidc_provider.arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
  tags = {
    tag-key = "AWSLoadBalancerControllerIAMPolicy"
  }
}

# Install AWS Load Balancer Controller using HELM
# Resource: Helm Release 
resource "helm_release" "loadbalancer_controller" {
  #   depends_on = [aws_iam_role.lbc_iam_role, aws_eks_node_group.eks_ng_private]
  depends_on = [module.load_balancer_controller_irsa_role, aws_eks_node_group.eks_ng_public]
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.8.1"
  namespace  = "kube-system"

  # Value changes based on your Region (Below is for us-east-1)
  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.ap-south-1.amazonaws.com/amazon/aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.load_balancer_controller_irsa_role.iam_role_arn
  }

  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }

  set {
    name  = "region"
    value = var.region
  }

  set {
    name  = "clusterName"
    value = aws_eks_cluster.eks_cluster.id
  }

}




# Datasource: AWS Load Balancer Controller IAM Policy get from aws-load-balancer-controller/ GIT Repo (latest)
data "http" "lbc_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}

# Resource: Create AWS Load Balancer Controller IAM Policy 
resource "aws_iam_policy" "lbc_iam_policy" {
  name        = "${local.name}-AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "AWS Load Balancer Controller IAM Policy"
  #policy = data.http.lbc_iam_policy.body
  policy = data.http.lbc_iam_policy.response_body
}

# Resource: Create IAM Role 
resource "aws_iam_role" "lbc_iam_role" {
  name = "${local.name}-lbc-iam-role"

  # Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "${aws_iam_openid_connect_provider.oidc_provider.arn}"
        }
        Condition = {
          StringEquals = {
            "${local.aws_iam_oidc_connect_provider_extract_from_arn}:aud" : "sts.amazonaws.com",
            "${local.aws_iam_oidc_connect_provider_extract_from_arn}:sub" : "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      },
    ]
  })

  tags = {
    tag-key = "AWSLoadBalancerControllerIAMPolicy"
  }
}

# Associate Load Balanacer Controller IAM Policy to  IAM Role
resource "aws_iam_role_policy_attachment" "lbc_iam_role_policy_attach" {
  policy_arn = aws_iam_policy.lbc_iam_policy.arn
  role       = aws_iam_role.lbc_iam_role.name
}

# Associate Load Balanacer Controller IAM Policy to  IAM Role
resource "aws_iam_role_policy_attachment" "lbc_iam_role_policy_attach_new" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.lbc_iam_role.name
}
