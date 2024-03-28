data "aws_iam_policy_document" "ec2-power-user" {
#  statement {
#    sid    = "MyEc2PowerUserPolicy"
#    effect = "Allow"
#
#    not_actions = [
#      "iam:*",
#      "organizations:*",
#      "account:*"
#    ]
#
#    resources = [
#      "*"
#    ]
#  }
#
  statement {
    sid = "AllowActions"
    effect = "Allow"

    actions = [
      "*"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "ec2-power-user" {
  name = "ec2-power-user"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = ["ec2.amazonaws.com", "eks.amazonaws.com", "ssm.amazonaws.com"]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = {
    instance-profile-role = "ec2-power-user"
  }
}

resource "aws_iam_role_policy" "ec2-power-user" {
  name = "ec2-power-user"
  role = aws_iam_role.ec2-power-user.id
  policy = data.aws_iam_policy_document.ec2-power-user.json
}

resource "aws_iam_instance_profile" "ec2-power-user" {
  name = "ec2-power-user"
  role = aws_iam_role.ec2-power-user.name
}
