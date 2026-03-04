terraform {
  backend "s3" {
    bucket       = "terraform-data-2025"
    key          = "tools/state"
    region       = "us-east-1"
  }
}

module "vault" {
  for_each = var.tools
  source = "./modules/vault"

  ami_id        = var.ami_id
  instance_type = each.value["instance_type"]
  port          = each.value["port"]
  tag_name      = each.key
  zone_id       = each.value["zone_id"]
}

