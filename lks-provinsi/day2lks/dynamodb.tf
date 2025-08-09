resource "aws_dynamodb_table" "techno_db" {
  name           = "techno-dynamodb"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "token"

  attribute {
    name = "token"
    type = "S"
  }

  tags = {
    Name        = "techno_db"
  }
}

resource "aws_dynamodb_kinesis_streaming_destination" "techno_db_kinesis" {
  stream_arn                               = aws_kinesis_stream.techno_kinesis_hida.arn
  table_name                               = aws_dynamodb_table.techno_db.name
  approximate_creation_date_time_precision = "MICROSECOND"
}