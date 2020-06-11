// Create a log group for the lambda
resource "aws_cloudwatch_log_group" "log_group_voting_consumer" {
  name = "/aws/lambda/voting_consumer"
}

resource "aws_cloudwatch_log_group" "log_group_voting_nominees" {
  name = "/aws/lambda/voting_nominees"
}
// Create a log group for the lambda
resource "aws_cloudwatch_log_group" "log_group_voting_result" {
  name = "/aws/lambda/voting_result"
}

# allow lambda to log to cloudwatch
data "aws_iam_policy_document" "cloudwatch_log_group_access_document" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:::*",
    ]
  }
}