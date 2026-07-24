module "securityhub" {
  source  = "blackbird-cloud/securityhub/aws"
  version = "~> 2.0"

  region = "eu-central-1"
}
