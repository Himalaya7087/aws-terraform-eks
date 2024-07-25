# VPC Output Values

# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# VPC CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# VPC Private Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

# VPC Public Subnets
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# VPC NAT gateway Public IP
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

# VPC AZs
output "azs" {
  description = "A list of availability zones spefified as argument to this module"
  value       = module.vpc.azs
}


# AWS EC2 Instance Terraform Outputs
# Public EC2 Instances - Bastion Host

## ec2_bastion_public_instance_ids
# output "ec2_bastion_public_instance_ids" {
#   description = "List of IDs of instances"
#   value       = module.ec2_public.id
# }

# output "ec2_bastion_public_instance_ip" {
#   description = "List of IDs of instances"
#   value       = module.ec2_public.public_ip
# }



# EKS Cluster Outputs
# output "cluster_id" {
#   description = "The name/id of the EKS cluster."
#   value       = aws_eks_cluster.eks_cluster.id
# }

# output "cluster_arn" {
#   description = "The Amazon Resource Name (ARN) of the cluster."
#   value       = aws_eks_cluster.eks_cluster.arn
# }

# output "cluster_certificate_authority_data" {
#   description = "Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster."
#   value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
# }

# output "cluster_endpoint" {
#   description = "The endpoint for your EKS Kubernetes API."
#   value       = aws_eks_cluster.eks_cluster.endpoint
# }

# output "cluster_version" {
#   description = "The Kubernetes server version for the EKS cluster."
#   value       = aws_eks_cluster.eks_cluster.version
# }

# output "cluster_iam_role_name" {
#   description = "IAM role name of the EKS cluster."
#   value       = aws_iam_role.eks_master_role.name
# }

# output "cluster_iam_role_arn" {
#   description = "IAM role ARN of the EKS cluster."
#   value       = aws_iam_role.eks_master_role.arn
# }

# output "cluster_oidc_issuer_url" {
#   description = "The URL on the EKS cluster OIDC Issuer"
#   value       = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
# }

# output "cluster_primary_security_group_id" {
#   description = "The cluster primary security group ID created by the EKS cluster on 1.14 or later. Referred to as 'Cluster security group' in the EKS console."
#   value       = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
# }

# # EKS Node Group Outputs - Public
# output "node_group_public_id" {
#   description = "Public Node Group ID"
#   value       = aws_eks_node_group.eks_ng_public.id
# }

# output "node_group_public_arn" {
#   description = "Public Node Group ARN"
#   value       = aws_eks_node_group.eks_ng_public.arn
# }

# output "node_group_public_status" {
#   description = "Public Node Group status"
#   value       = aws_eks_node_group.eks_ng_public.status
# }

# output "node_group_public_version" {
#   description = "Public Node Group Kubernetes Version"
#   value       = aws_eks_node_group.eks_ng_public.version
# }

# #EBS-CSI Driver IAM Policy
# output "ebs_csi_iam_policy" {
#   value = data.http.ebs_csi_iam_policy.response_body
# }

# output "ebs_csi_iam_role_arn" {
#   description = "EBS CSI IAM Role ARN"
#   value       = aws_iam_role.ebs_csi_iam_role.arn
# }
