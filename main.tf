terraform {

}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_iam_role" "default" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_lambda_function" "default" {
  function_name = "test_lambda"
  handler = "app.lambda_handler"
  package_type = "Image"
  role          = aws_iam_role.default.arn
  image_uri = "123456789012.dkr.ecr.eu-west-1.amazonaws.com/test_lambda:latest"
}

resource "null_resource" "sam_metadata_function" {
  triggers = {
    resource_name = "aws_lambda_function.default"
    resource_type = "IMAGE_LAMBDA_FUNCTION"
    docker_context = "./src"
    docker_file = "Dockerfile"
    docker_build_args = jsonencode({})

    docker_tag = "latest"
  }
}