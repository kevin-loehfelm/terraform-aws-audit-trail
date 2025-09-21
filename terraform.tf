terraform {
  required_version = ">= 1.6.0" # BUSL License
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.14.0" # Sep 19 2025
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.1" # Sep 19 2025
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.69.0" # Sep 19 2025
    }
  }
}