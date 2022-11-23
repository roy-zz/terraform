provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_iam_user" "devops_user" {
  name = "devops-user"
}

resource "aws_iam_group" "devops_group" {
  name = "devops-group"
}

resource "aws_iam_group_membership" "devops" {
  name = aws_iam_group.devops_group.name

  users = [
    aws_iam_user.devops_user.name
  ]

  group = aws_iam_group.devops_group.name
}
