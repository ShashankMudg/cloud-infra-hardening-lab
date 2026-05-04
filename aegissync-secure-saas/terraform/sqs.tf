resource "aws_sqs_queue" "queue" {
  name = "aegissync-queue"
}

resource "aws_lambda_event_source_mapping" "sqs" {
  event_source_arn = aws_sqs_queue.queue.arn
  function_name    = aws_lambda_function.worker.arn
}