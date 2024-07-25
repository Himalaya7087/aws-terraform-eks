# Resource: EBS CSI Driver AddOn
# Install EBS CSI Driver using EKS Add-Ons
resource "aws_eks_addon" "ebs_eks_addon" {
  # depends_on               = [aws_iam_role_policy_attachment.ebs_csi_iam_role_policy_attach, aws_eks_node_group.eks_ng_private]
  depends_on               = [module.ebs_csi_irsa_role, aws_eks_node_group.eks_ng_public]
  cluster_name             = aws_eks_cluster.eks_cluster.id
  addon_version            = "v1.32.0-eksbuild.1"
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
}

# Create IRSA for EBS CSI Driver using Terraform Modules
module "ebs_csi_irsa_role" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version               = "5.9.2"
  role_name             = "ebs-csi-eks-role"
  attach_ebs_csi_policy = true
  oidc_providers = {
    eks-cluster = {
      provider_arn               = aws_iam_openid_connect_provider.oidc_provider.arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
  tags = {
    tag-key = "AWSEBSCSIControllerIAMPolicy"
  }
}

# # Datasource: EBS CSI IAM Policy get from EBS GIT Repo (latest)
# data "http" "ebs_csi_iam_policy" {
#   url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json"

#   # Optional request headers
#   request_headers = {
#     Accept = "application/json"
#   }
# }

# #data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_arn
# #data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_extract_from_arn

# # Resource: Create EBS CSI IAM Policy 
# resource "aws_iam_policy" "ebs_csi_iam_policy" {
#   name        = "${local.name}-AmazonEKS_EBS_CSI_Driver_Policy"
#   path        = "/"
#   description = "EBS CSI IAM Policy"
#   policy      = data.http.ebs_csi_iam_policy.response_body
# }

# output "ebs_csi_iam_policy_arn" {
#   value = aws_iam_policy.ebs_csi_iam_policy.arn
# }

# # Resource: Create IAM Role and associate the EBS IAM Policy to it
# resource "aws_iam_role" "ebs_csi_iam_role" {
#   name = "${local.name}-ebs-csi-iam-role"

#   # Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRoleWithWebIdentity"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Federated = "${aws_iam_openid_connect_provider.oidc_provider.arn}"
#         }
#         Condition = {
#           StringEquals = {
#             "${local.aws_iam_oidc_connect_provider_extract_from_arn}:sub" : "system:serviceaccount:kube-system:ebs-csi-controller-sa"
#           }
#         }

#       },
#     ]
#   })

#   tags = {
#     tag-key = "${local.name}-ebs-csi-iam-role"
#   }
# }

# # Associate EBS CSI IAM Policy to EBS CSI IAM Role
# resource "aws_iam_role_policy_attachment" "ebs_csi_iam_role_policy_attach" {
#   policy_arn = aws_iam_policy.ebs_csi_iam_policy.arn
#   role       = aws_iam_role.ebs_csi_iam_role.name
# }


