resource "aws_iam_role" "main" {
  name = "${var.tag_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "main" {
  name = "${var.tag_name}-profile"
  role = aws_iam_role.main.name
}


resource "aws_iam_policy" "policy" {
  name        = "${var.tag_name}-role-policy"
  path        = "/"
  description = "${var.tag_name}-role-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = local.policy_action
        Effect   = "Allow"
        Resource = length(var.iam_policy["Resource"]) == 0 ? ["*"] : var.iam_policy["Resource"]
      },
    ]
  })
}