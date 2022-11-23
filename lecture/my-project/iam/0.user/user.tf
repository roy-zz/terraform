provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_iam_user" "inho_choi" {
  name = "inho.choi"
}