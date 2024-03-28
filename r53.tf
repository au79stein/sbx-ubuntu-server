data "aws_instances" "asg_instances" {
  instance_tags = {
    Name = "generic_ubuntu_test"
  }
  instance_state_names = ["running"]
}

output ids {
  value = data.aws_instances.asg_instances.ids
}

data "aws_route53_zone" "terrorgrump" {
  name         = "terrorgrump.com"
  private_zone = false
}

resource "aws_route53_record" "grafana" {
  zone_id = data.aws_route53_zone.terrorgrump.zone_id
  name    = "grafana.${data.aws_route53_zone.terrorgrump.name}"
  type    = "A"
  ttl     = "300"
  records = ["54.212.24.1"]
}
