#data "aws_ami" "amazon_linux" {
#  most_recent = true
#  owners      = ["amazon"]
#
#  filter {
#    name   = "name" 
#    values = ["amzn-ami-hvm-*-x86_64-gp2"]
#  }
#}
#
#data "aws_ami" "amazon_linux_23" {
#  most_recent = true
#  owners      = ["amazon"]
#
#  filter {
#    name   = "name"
#    values = ["al2023-ami-2023*-x86_64"]
#  }
#}

#data "aws_ami" "ubuntu" {
#  most_recent = true
#  owners      = ["099720109477"] # Canonical
#
#  filter {
#    name   = "name"
#    values = ["ubuntu/images/hvm-ssd/ubuntu-lunar-23.04-amd64-server-*"]
#  }
#}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"
    ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


###########################################

resource "aws_launch_template" "ubserver_lt" {
  name = "ubuntu_server_templ"
  #name_prefix   = "kubernetes_the_hard_way"
  image_id      = data.aws_ami.ubuntu.id
  #instance_type = "t2.micro"
  instance_type = "t3.medium"
  key_name      = "ghcir812"
  user_data     = filebase64("./user_data/web.sh")

  iam_instance_profile {
    name = "ec2-power-user"
  }

  network_interfaces {
  #  subnet_id                   = element(module.vpc.public_subnets, 0)
    security_groups             = [module.security_group.security_group_id]
    associate_public_ip_address = true
  }

  placement {
  #  availability_zone           = element(module.vpc.azs, 0)
  #  availability_zone           = "us-west-2a"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "generic_ubuntu_test"
    }
  }
}


resource "aws_autoscaling_group" "ubserver_asg" {
  #vpc_zone_identifier = module.vpc.public_subnets
  availability_zones = ["us-west-2a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 0

  launch_template {
    id      = aws_launch_template.ubserver_lt.id
    version = "$Latest"
  }

  #provisioner "local-exec" {
  #  command = "./user_data/getips.sh"
  #}
}
