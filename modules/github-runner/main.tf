resource "aws_instance" "tool" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids

  tags = {
    Name = var.tag_name
  }
}

resource "aws_route53_record" "records" {
  zone_id = var.zone_id
  name    = "${var.tag_name}-internal"
  type    = "A"
  ttl     = 30
  records = [aws_instance.tool.private_ip]
}


# resource "aws_vpc_security_group_ingress_rule" "allow_app_port" {
#   security_group_id = var.vpc_security_group_ids
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = var.port
#   ip_protocol       = "tcp"
#   to_port           = var.port
#   description       = "${var.tag_name}_github_runner_port_dummy"
# }
# resource "null_resource" "github-runner-code" {
#   depends_on = [aws_route53_record.records]
#
#   triggers = {
#     #instance_id_change = aws_instance.instances.id
#     always_run = timestamp()
#   }
#   provisioner "remote-exec" {
#
#     connection {
#       type     = "ssh"
#       user     = data.vault_generic_secret.sample.data["username"]
#       #      private_key = file(var.private_key_pem)
#       password = data.vault_generic_secret.sample.data["password"]
#       host     = aws_instance.tool.private_ip
#     }
#
#     inline = [
#       "sudo python3.11 -m pip install ansible hvac",
#       "ansible-pull -i localhost, -U https://github.com/Manju9876/roboshop-ansible-2025 roboshop.yaml -e component_name=${var.docker_component_name} -e env=${var.env} -e vault_token=${var.vault_token}"
#     ]
#   }
# }
