# resource "helm_release" "cluster-autoscaler" {
#   depends_on = [aws_iam_role.kubernetes_cluster_autoscaler, aws_eks_node_group.eks_ng_private]
#   name       = "aws-cluster-autoscaler"
#   repository = "https://kubernetes.github.io/autoscaler"
#   chart      = "cluster-autoscaler"
#   version    = "9.34.0"
#   namespace  = "kube-system"

#   set {
#     name  = "rbac.serviceAccount.create"
#     value = "true"
#   }

#   set {
#     name  = "rbac.serviceAccount.name"
#     value = "cluster-autoscaler"
#   }

#   set {
#     name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = aws_iam_role.kubernetes_cluster_autoscaler.arn
#   }

#   set {
#     name  = "ggawsRegion"
#     value = var.region
#   }

#   set {
#     name  = "autoDiscovery.clusterName"
#     value = aws_eks_cluster.eks_cluster.id
#   }

# }
