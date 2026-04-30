resource "aws_dynamodb_table" "db" {
  name         = "transactions"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  attribute {
    name = "id"
    type = "S"
  }
  server_side_encryption {
    enabled = true
  }
}

resource "aws_s3_bucket" "logs" {
  bucket = "logs-secure-audit-bucket" # Unique name manually or use random_id if defined here
}