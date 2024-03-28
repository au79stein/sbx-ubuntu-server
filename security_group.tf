module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "kubernetes_the_hard_way_sg"
  description = "Security group for example usage with EC2 instance"
  #vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp", "ssh-tcp", "all-icmp" ]
  egress_rules        = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port = 8080
      to_port   = 8080
      protocol  = "tcp"
      description = " port 8080 for access"
      cidr_blocks = "149.57.0.0/16"
      #cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port = 3000
      to_port   = 3000
      protocol  = "tcp"
      description = " port 3000 for access"
      cidr_blocks = "149.57.0.0/16"
      #cidr_blocks = "0.0.0.0/0"
    }
  ]

  #tags = local.tags
}
