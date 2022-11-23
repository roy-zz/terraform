provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_iam_user" "devops_user" {
  name = "devops.user"
}