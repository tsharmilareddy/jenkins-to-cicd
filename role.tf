resource "aws_iam_role" "role" {
  name = "ec2-artifactory"

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

  tags = {
    tag-key = "role"
  }
}





# #create policy

resource "aws_iam_policy" "policy" {
  name        = "policy1"
  path        = "/"
  description = "My test policy"


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

#attachement
resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}


#ec2-attachement



resource "aws_iam_instance_profile" "instance" {
  name = "cicd"
  role = aws_iam_role.role.name
}
