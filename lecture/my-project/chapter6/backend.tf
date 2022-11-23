terraform {
  backend "s3" {
    bucket = "terraform-roy-apne2-tfstate"
    key = "terraform/roy/terraform.tfstate"
    region = "ap-northeast-2"
    encrypt = true
    dynamodb_table = "terraform-lock"
  }
}