# This block configures Terraform itself. See https://www.terraform.io/docs/configuration/terraform.html
terraform {
  required_version = ">= 0.10.0"

  backend "s3" {
    bucket = "unidata-nexus-iac"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
