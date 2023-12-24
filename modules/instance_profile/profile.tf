
resource "aws_iam_role" "iam_role" {
  name = "instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Define an IAM policy that allows access to DynamoDB
resource "aws_iam_policy" "dynamodb_policy" {
  name        = "DynamoDBFullAccess"
  description = "A policy that allows full access to DynamoDB"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": "dynamodb:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "dynamo_policy_attachment" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "instance-profile"
  role = aws_iam_role.iam_role.name
}
