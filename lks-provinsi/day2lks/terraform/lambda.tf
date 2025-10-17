resource "aws_lambda_function" "lambda_s3" {
  function_name = "techno-lambda-s3"
  handler       = "lambda_s3.lambda_handler"
  runtime       = "python3.12"
  timeout       = 120
  role          = "arn:aws:iam::641191776011:role/LabRole"
  filename      = "lambda_s3.zip"

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.techno_topic.name
      KINESIS_STREAM_NAME = aws_kinesis_stream.techno_kinesis_hida.name
      DEST_BUCKET = aws_s3_bucket.technooutput_hida.bucket
    }
  }

}

resource "aws_lambda_function" "lambda_post" {
  function_name = "techno-lambda-post"
  handler       = "lambda_post.lambda_handler"
  runtime       = "python3.12"
  timeout       = 60
  role          = "arn:aws:iam::641191776011:role/LabRole"
  filename      = "lambda_post.zip"

}

resource "aws_lambda_function" "lambda_get" {
  function_name = "techno-lambda-get"
  handler       = "lambda_get.lambda_handler"
  runtime       = "python3.12"
  timeout       = 90
  role          = "arn:aws:iam::641191776011:role/LabRole"
  filename      = "lambda_get.zip"

  environment {
    variables = {
      TOKEN_TABLE = aws_dynamodb_table.techno_db.name
    }
  }

}

resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = aws_s3_bucket.technoinput_hida.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_s3.arn
    events              = ["s3:ObjectCreated:*"]

  }
}

resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_s3.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.technoinput_hida.arn

}
