terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60.0"  # Try an earlier version
    }
  }
}

provider "aws" {
  region = "ap-south-1"  # Adjust to your region
}

