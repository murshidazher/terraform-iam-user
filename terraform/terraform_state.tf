# terraform_state.tf
terraform {
  backend "s3" {
    encrypt = true
    bucket  = "terraform-hadoop-openvpn"
    key     = "sandbox-iam-terraform/terraform.tfstate"
    region  = "us-east-1"
  }
}
