terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "cert" {
  name = var.username
}

resource "aws_iam_access_key" "cert" {
  user = aws_iam_user.cert.name
}

resource "aws_iam_user_policy" "cert_po" {
  user = aws_iam_user.cert.name

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "route53:ListHostedZones"
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "route53:GetHostedZone",
            "route53:ListResourceRecordSets",
            "route53:ChangeResourceRecordSets"
          ],
          "Resource" : "arn:aws:route53:::hostedzone/${var.hosted_zone_id}"
        }
      ]
    }
  )
}
