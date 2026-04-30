output "lambda_arn" {
  value = aws_lambda_function.app.arn
}

output "lambda_name" {
  value = aws_lambda_function.app.function_name
}