terraform {
  cloud {
    organization = "NREL"
    workspaces {
      name = "terraform-test-deploy"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}