# This block configures Terraform itself. See https://www.terraform.io/docs/configuration/terraform.html
terraform {
  required_version = ">= 0.10.0"

  backend "s3" {
    bucket = "${var.bucket}"
    key    = "${var.key}"
    region = "${var.region}"

    encrypt = "${var.encrypt}"
  }
}
