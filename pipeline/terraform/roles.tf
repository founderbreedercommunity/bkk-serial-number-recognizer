resource "aws_iam_role" "lambda_execution_role" {
  name = local.basic_lambda_role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "lambda_basic_execution" {
name = local.basic_lambda_policy_name
role = aws_iam_role.lambda_execution_role.id
policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
           "rekognition:DetectText",
          "rekognition:GetTextDetection",
          "rekognition:DescribeProjects",
          "rekognition:DescribeProjectVersions",
          "s3:*"
      ],
      "Resource": ["*"]
    }
  ]
}
EOF
}
