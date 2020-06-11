provider "aws" {
  region="eu-west-2"
}

resource "aws_kinesis_stream" "voting_stream" {
  name             = "terraform-kinesis-voting"
  shard_count      = 1
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  tags = {
    Environment = "test"
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy =<<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
}
EOF
}

resource "aws_lambda_function" "voting_consumer_fn" {

  vpc_config {
    subnet_ids = "${aws_subnet.default.*.id}"
    security_group_ids = [aws_security_group.default.id]
  }
  runtime          = var.lambda_runtime
  filename      = var.lambda_payload_filename
  source_code_hash = base64sha256(filebase64(var.lambda_payload_filename))
  function_name = "voting_consumer_fn"
  # lambda handler function name, it will be full class path name with package name
  handler          = var.lambda_function_handler
  timeout = 60
  memory_size = 256
  # role for lambda is defined in aws-iam_role resource
  role             = aws_iam_role.iam_role_for_lambda.arn
  depends_on   = [aws_cloudwatch_log_group.log_group_voting_consumer]
  environment {
    variables = {
      CAMPAIGN_FILE_NAME = var.campaign_file_name
    }
  }
}

resource "aws_lambda_function" "voting_nominees_fn" {

  vpc_config {
    subnet_ids = "${aws_subnet.default.*.id}"
    security_group_ids = [aws_security_group.default.id]
  }
  runtime          = var.lambda_runtime
  filename      = var.lambda_payload_filename
  source_code_hash = base64sha256(filebase64(var.lambda_payload_filename))
  function_name = "voting_nominees_fn"
  # lambda handler function name, it will be full class path name with package name
  handler          = var.lambda_nominees_function_handler
  timeout = 60
  memory_size = 256
  # role for lambda is defined in aws-iam_role resource
  role             = aws_iam_role.iam_role_for_lambda.arn
  depends_on   = [aws_cloudwatch_log_group.log_group_voting_nominees]
  environment {
    variables = {
      CAMPAIGN_FILE_NAME = var.campaign_file_name
    }
  }
}


resource "aws_lambda_function" "voting_result_fn" {

  vpc_config {
    subnet_ids = "${aws_subnet.default.*.id}"
    security_group_ids = [aws_security_group.default.id]
  }
  runtime          = var.lambda_runtime
  filename      = var.lambda_payload_result_filename
  source_code_hash = base64sha256(filebase64(var.lambda_payload_filename))
  function_name = "voting_result_fn"
  # lambda handler function name, it will be full class path name with package name
  handler          = var.lambda_voting_result_function_handler
  timeout = 60
  memory_size = 256
  # role for lambda is defined in aws-iam_role resource
  role             = aws_iam_role.iam_role_for_lambda.arn
  depends_on   = [aws_cloudwatch_log_group.log_group_voting_result]
  environment {
    variables = {
      CAMPAIGN_FILE_NAME = var.campaign_file_name
    }
  }

}


resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn  = aws_kinesis_stream.voting_stream.arn
  function_name     = aws_lambda_function.voting_consumer_fn.arn
  starting_position = "TRIM_HORIZON"
  maximum_retry_attempts = 3
  enabled = true
}
