#Input Variables
aws_region  = "ap-south-1"
environment = "dev"

#VPC Variables
vpc_name                               = "dev-vpc"
vpc_cidr_block                         = "10.21.0.0/16"
vpc_public_subnets                     = ["10.21.1.0/24", "10.21.2.0/24"]
vpc_private_subnets                    = ["10.21.3.0/24", "10.21.4.0/24"]
vpc_database_subnets                   = ["10.21.5.0/24", "10.21.6.0/24"]
vpc_create_database_subnet_group       = false
vpc_create_database_subnet_route_table = false
vpc_enable_nat_gateway                 = true
vpc_single_nat_gateway                 = true


#BASTION Host Variables
instance_type    = "t2.micro"
instance_keypair = "demo"

#EKS Variables
cluster_name                         = "mbp-eks"
cluster_service_ipv4_cidr            = "172.20.0.0/16"
cluster_version                      = "1.30"
cluster_endpoint_private_access      = true
cluster_endpoint_public_access       = true
cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
eks_oidc_root_ca_thumbprint          = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"




