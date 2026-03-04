terraform {
  backend "s3" {
    bucket = "terraform-data-2025}"
    key    = "vault-secrets/state"
    region = "us-east-1"
  }
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "5.0.0"
    }
  }
}

resource "vault_mount" "infra_access" {
  path        = "infra"
  type        = "kv"
  options     = { version = "2" }
  description = "ec2 instance infra access"
}

resource "vault_mount" "roboshop-dev" {
  path        = "roboshop-dev-secrets"
  type        = "kv"
  options     = { version = "2" }
  description = "roboshop dev secrets"
}

resource "vault_mount" "roboshop-dev-docker" {
  path        = "roboshop-dev-docker-secrets"
  type        = "kv"
  options     = { version = "2" }
  description = "roboshop dev secrets"
}

resource "vault_mount" "expense-dev" {
  path        = "expense-dev-secrets"
  type        = "kv"
  options     = { version = "2" }
  description = "expense dev secrets"
}

resource "vault_generic_secret" "infra_access" {
  path = "${vault_mount.infra_access.path}/ssh"

  data_json = <<EOT
{
  "username": "ec2-user",
  "password": "DevOps321"
}
EOT
}

resource "vault_generic_secret" "cart" {
  path = "${vault_mount.roboshop-dev.path}/cart"

  data_json = <<EOF
{
  "REDIS_HOST": "redis-dev.devopsbymanju.shop",
  "CATALOGUE_HOST": "catalogue-dev.devopsbymanju.shop",
  "CATALOGUE_PORT": "8080"
}
EOF
}


resource "vault_generic_secret" "catalogue" {
  path = "${vault_mount.roboshop-dev.path}/catalogue"

  data_json = <<EOT
{
  "MONGO_URL": "mongodb://mongodb-dev.devopsbymanju.shop:27017/catalogue",
  "MONGO": "true",
  "DB_TYPE": "mongo",
  "APP_GIT_URL": "https://github.com/roboshop-devops-project-v3/catalogue",
  "DB_HOST": "mongodb-dev.devopsbymanju.shop",
  "SCHEMA_FILE": "db/master-data.js"
}
EOT
}



resource "vault_generic_secret" "user" {
  path = "${vault_mount.roboshop-dev.path}/user"

  data_json = <<EOF
{
 "REDIS_URL": "redis://redis-dev.devopsbymanju.shop:6379",
 "MONGO_URL": "mongodb://mongodb-dev.devopsbymanju.shop:27017/users",
 "MONGO": "true"
}
EOF
}

resource "vault_generic_secret" "shipping" {
  path = "${vault_mount.roboshop-dev.path}/shipping"

  data_json = <<EOF
{
 "CART_ENDPOINT": "cart-dev.devopsbymanju.shop:8080",
 "DB_HOST": "mysql-dev.devopsbymanju.shop",
 "DB_TYPE": "mysql",
 "APP_GIT_URL": "https://github.com/roboshop-devops-project-v3/shipping",
 "DB_USER": "root",
 "DB_PASS": "RoboShop@1",
 "SCHEMA_FILE": {
   "app_user": "db/app-user.sql",
   "schema": "db/schema.sql",
   "master_data": "db/master-data.sql"
 }

}
EOF
}

resource "vault_generic_secret" "payment" {
  path = "${vault_mount.roboshop-dev.path}/payment"

  data_json = <<EOT
{
  "AMQP_HOST": "rabbitmq-dev.devopsbymanju.shop",
  "CART_HOST": "cart-dev.devopsbymanju.shop",
  "CART_PORT": "8080",
  "USER_HOST": "user-dev.devopsbymanju.shop",
  "USER_PORT": "8080",
  "AMQP_USER": "roboshop",
  "AMQP_PASS": "roboshop123"
}
EOT
}



resource "vault_generic_secret" "dispatch" {
  path = "${vault_mount.roboshop-dev.path}/dispatch"

  data_json = <<EOF
{
  "AMQP_HOST": "rabbitmq-dev.devopsbymanju.shop",
  "AMQP_USER": "roboshop",
  "AMQP_PASS": "roboshop123"
}
EOF
}

resource "vault_generic_secret" "backend" {
  path = "${vault_mount.expense-dev.path}/backend"

  data_json = <<EOF
{
  "DB_HOST": "mysql-dev.devopsbymanju.shop"
}
EOF
}


resource "vault_generic_secret" "frontend" {
  path = "${vault_mount.roboshop-dev.path}/frontend"

  data_json = <<EOF
{
  "catalogue": "http://catalogue-dev.devopsbymanju.shop:8080/;",
  "user": "http://user-dev.devopsbymanju.shop:8080/;",
  "cart": "http://cart-dev.devopsbymanju.shop:8080/;",
  "shipping": "http://shipping-dev.devopsbymanju.shop:8080/;",
  "payment": "http://payment-dev.devopsbymanju.shop:8080/;",
  "CATALOGUE_HOST": "catalogue-dev.devopsbymanju.shop",
  "CATALOGUE_PORT": "8080",
  "USER_HOST": "user-dev.devopsbymanju.shop",
  "USER_PORT": "8080",
  "CART_HOST": "cart-dev.devopsbymanju.shop",
  "CART_PORT": "8080",
  "SHIPPING_HOST": "shipping-dev.devopsbymanju.shop",
  "SHIPPING_PORT": "8080",
  "PAYMENT_HOST": "payment-dev.devopsbymanju.shop",
  "PAYMENT_PORT": "8080"
}
EOF
}


#
# resource "vault_generic_secret" "frontend-docker" {
#   path = "${vault_mount.roboshop-dev-docker.path}/frontend-docker"
#
#   data_json = <<EOF
# {
#   "CATALOGUE_HOST": "catalogue-dev.devopsbymanju.shop",
#   "CATALOGUE_PORT": "8080",
#   "USER_HOST": "user-dev.devopsbymanju.shop",
#   "USER_PORT": "8080",
#   "CART_HOST": "cart-dev.devopsbymanju.shop",
#   "CART_PORT": "8080",
#   "SHIPPING_HOST": "shipping-dev.devopsbymanju.shop",
#   "SHIPPING_PORT": "8080",
#   "PAYMENT_HOST": "payment-dev.devopsbymanju.shop",
#   "PAYMENT_PORT": "8080"
# }
# EOF
# }

