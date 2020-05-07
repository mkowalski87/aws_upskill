variable "name" {
  description = "name of the lambda funciton"
}

variable "runtime" {
  description = "The runtime of the lambda to create"
  default     = "python3.7"
}

variable "handler" {
  description = "The handler name of the lambda (a function defined in your lambda)"
  default     = "handler"
}

variable "role" {
  description = "IAM role attached to the Lambda Function (ARN)"
}

resource "aws_lambda_function" "lambda" {
  filename      = "package.zip"
  function_name = "${var.name}_${var.handler}"
  role          = "${var.role}"
  handler       = "${var.name}.${var.handler}"
  runtime       = "${var.runtime}"
}

output "name" {
  value = "${aws_lambda_function.lambda.function_name}"
}