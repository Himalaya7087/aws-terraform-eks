# # Policy
# data "aws_iam_policy_document" "kubernetes_cluster_autoscaler" {
#   statement {
#     actions = [
#       "autoscaling:DescribeAutoScalingGroups",
#       "autoscaling:DescribeAutoScalingInstances",
#       "autoscaling:DescribeLaunchConfigurations",
#       "autoscaling:DescribeTags",
#       "autoscaling:SetDesiredCapacity",
#       "autoscaling:TerminateInstanceInAutoScalingGroup",
#       "ec2:DescribeLaunchTemplateVersions",
#       "ec2:DescribeInstanceTypes"
#     ]
#     resources = [
#       "*",
#     ]
#     effect = "Allow"
#   }

# }

# resource "aws_iam_policy" "kubernetes_cluster_autoscaler" {
#   name        = "${var.cluster_name}-cluster-autoscaler"
#   path        = "/"
#   description = "Policy for cluster autoscaler service"

#   policy = data.aws_iam_policy_document.kubernetes_cluster_autoscaler.json
# }

# # Role
# data "aws_iam_policy_document" "kubernetes_cluster_autoscaler_assume" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]

#     principals {
#       type        = "Federated"
#       identifiers = [aws_iam_openid_connect_provider.oidc_provider.arn]
#     }

#     condition {
#       test     = "StringEquals"
#       variable = "${replace(local.aws_iam_oidc_connect_provider_extract_from_arn, "https://", "")}:sub"

#       values = [
#         "system:serviceaccount:kube-system:cluster-autoscaler",
#       ]
#     }
#     effect = "Allow"
#   }
# }

# resource "aws_iam_role" "kubernetes_cluster_autoscaler" {
#   name               = "${var.cluster_name}-cluster-autoscaler"
#   assume_role_policy = data.aws_iam_policy_document.kubernetes_cluster_autoscaler_assume.json
# }

# resource "aws_iam_role_policy_attachment" "kubernetes_cluster_autoscaler" {
#   role       = aws_iam_role.kubernetes_cluster_autoscaler.name
#   policy_arn = aws_iam_policy.kubernetes_cluster_autoscaler.arn
# }
