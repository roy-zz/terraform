provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_iam_user" "devops_user" {
  name = "devops.user"
}

resource "aws_iam_user_policy" "devops_policy" {
  name = "devops-admin"
  user = aws_iam_user.devops_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}