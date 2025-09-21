terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0"
    }
  }
}