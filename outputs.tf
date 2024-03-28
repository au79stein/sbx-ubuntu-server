#data "http" "my_public_ip" {
#  url = "https://ifconfig.co/json"
#  request_headers = {
#    Accept = "application/json"
#  }
#}

#locals {
#  //ifconfig_co_json = jsondecode(data.http.my_public_ip.body)
#  ifconfig_co_json = jsondecode(data.http.my_public_ip.response_body)
#}

data "aws_instances" "web_instances" {
  instance_state_names = ["running"]
}

output "instance_state_privip" {
  description = "Instance Private IPs"
  value = data.aws_instances.web_instances.private_ips
}

output "instance_state_pubip" {
  description = "Instance Public IPs"
  value = data.aws_instances.web_instances.public_ips
}

#output "my_ip_addr" {
#  value = local.ifconfig_co_json.ip
#}
