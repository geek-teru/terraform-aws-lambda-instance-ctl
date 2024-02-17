# ----------------------------------------
# Provider Settings
# ----------------------------------------
provider "aws" {
  #profile = "dev-terraform"
  region  = "ap-northeast-1"
}

terraform {
  required_version = ">= 1.5.0"
}