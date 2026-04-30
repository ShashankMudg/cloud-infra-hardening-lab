# --- modules/compute/variables.tf ---

variable "private_subnets" {
  type = list(string)
}

variable "db_table_arn" {
  type = string
}

# New Variable Added to fix "Unsupported Argument" error
variable "lambda_sg_id" {
  type = string
  description = "Security Group ID for the Lambda function"
}