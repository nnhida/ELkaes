resource "aws_kinesis_stream" "techno_kinesis_hida" {
  name             = "techno-kinesis-hida"
  shard_count      = 1
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  tags = {
    Name = "techno-kinesis-hida"
  }
}