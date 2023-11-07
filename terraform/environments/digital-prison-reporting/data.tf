# Get the environments file from the main repository
data "http" "environments_file" {
  url = "https://raw.githubusercontent.com/ministryofjustice/modernisation-platform/main/environments/${local.application_name}.json"
}
# TLS certificate data
data "tls_certificate" "circleci" {
  url = "https://oidc.circleci.com/org/${data.aws_secretsmanager_secret_version.circleci.secret_string}/.well-known/openid-configuration"
}

terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
  }
  required_version = "~> 1.0"
}
