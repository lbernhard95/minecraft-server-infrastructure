terraform {
  required_version = ">=1.9.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.73.0"
    }
  }
  backend "s3" {
    bucket         = "terraform-states-082113759242"
    dynamodb_table = "terraform-lock"
    key            = "minecraft-server.tfstate"
    region         = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      application = "MinecraftServer"
    }
  }
}
