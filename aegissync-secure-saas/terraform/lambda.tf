resource "aws_lambda_function" "api" {
  function_name = "aegissync-api"
  runtime       = "python3.9"
  handler       = "api.lambda_handler"
  role          = aws_iam_role.lambda_role.arn

  filename = "../lambda/api.zip"

  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  
}

resource "aws_lambda_function" "worker" {
  function_name = "aegissync-worker"
  runtime       = "python3.9"
  handler       = "worker.lambda_handler"
  role          = aws_iam_role.lambda_role.arn

  filename = "../lambda/worker.zip"

  vpc_config {
    subnet_ids         = aws_subnet.private[*].id
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}