# # AWS EC2 Instance Terraform Module
# # Bastion Host - EC2 Instance that will be created in VPC Public Subnet
# module "ec2_public" {
#   source = "terraform-aws-modules/ec2-instance/aws"
#   #version = "3.3.0"
#   version = "5.0.0"

#   # insert the required variables here
#   name          = "${local.name}-BastionHost"
#   ami           = data.aws_ami.amzlinux2.id
#   instance_type = var.instance_type
#   key_name      = var.instance_keypair
#   #monitoring             = true
#   subnet_id              = module.vpc.public_subnets[0]
#   vpc_security_group_ids = [module.public_bastion_sg.security_group_id]
#   tags                   = local.common_tags
# }

# # AWS EC2 Security Group Terraform Module
# # Security Group for Public Bastion Host
# module "public_bastion_sg" {
#   source = "terraform-aws-modules/security-group/aws"
#   #version = "4.5.0"
#   version = "4.17.2"

#   name        = "${local.name}-public-bastion-sg"
#   description = "Security Group with SSH port open for everybody (IPv4 CIDR), egress ports are all world open"
#   vpc_id      = module.vpc.vpc_id
#   # Ingress Rules & CIDR Blocks
#   ingress_rules       = ["ssh-tcp"]
#   ingress_cidr_blocks = ["0.0.0.0/0"]
#   # Egress Rule - all-all open
#   egress_rules = ["all-all"]
#   tags         = local.common_tags
# }

# resource "null_resource" "copy_ec2_keys" {
#   depends_on = [module.ec2_public]
#   # Connection Block for Provisioners to connect to EC2 Instance
#   connection {
#     type        = "ssh"
#     host        = module.ec2_public.public_ip
#     user        = "ec2-user"
#     password    = ""
#     private_key = file("env/${var.environment}/eks-keypair.pem")
#   }

#   ## File Provisioner: Copies the terraform-key.pem file to /tmp/terraform-key.pem
#   provisioner "file" {
#     source      = "env/${var.environment}/eks-keypair.pem"
#     destination = "/tmp/eks-terraform-key.pem"
#   }
#   ## Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
#   provisioner "remote-exec" {
#     inline = [
#       "sudo chmod 400 /tmp/eks-terraform-key.pem"
#     ]
#   }
# }

# # Get latest AMI ID for Amazon Linux2 OS
# data "aws_ami" "amzlinux2" {
#   most_recent = true
#   owners      = ["amazon"]
#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-gp2"]
#   }
#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }
# }
