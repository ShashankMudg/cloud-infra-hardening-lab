resource "aws_iam_role" "lambda_role" {
  name = "lambda_exec"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_lambda_function" "app" {
  function_name = "secure-app"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.10"
  filename      = "lambda.zip"
  vpc_config {
    subnet_ids         = var.private_subnets
    security_group_ids = [var.lambda_sg_id] 
  }
}