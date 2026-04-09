resource "aws_security_group" "tool" {
  name        = "${var.tag_name}-sg"
  description = "${var.tag_name} security group"

  tags = {
    Name = "${var.tag_name}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.tool.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  description       = "allow_port_22"
}

resource "aws_vpc_security_group_ingress_rule" "allow_app_port" {
  security_group_id = aws_security_group.tool.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.port
  ip_protocol       = "tcp"
  to_port           = var.port
  description       = "${var.tag_name}_vault_app_port"
}

resource "aws_vpc_security_group_egress_rule" "egress_allow_all_traffic" {
  security_group_id = aws_security_group.tool.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "tool" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.tool.id]

  instance_market_options {
    market_type = "spot"

    spot_options {
      instance_interruption_behavior = "stop"
      spot_instance_type = "persistent"

    }
  }
  tags = {
    Name = var.tag_name
  }
}

resource "aws_route53_record" "private" {
  zone_id = var.zone_id
  name    = "${var.tag_name}-internal"
  type    = "A"
  ttl     = 30
  records = [aws_instance.tool.private_ip]
}

resource "aws_route53_record" "public" {
  zone_id = var.zone_id
  name    = var.tag_name
  type    = "A"
  ttl     = 30
  records = [aws_instance.tool.public_ip]
}

