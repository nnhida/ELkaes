resource "aws_sns_topic" "techno_topic" {
  name = "techno-sns-malang-hida"
}

resource "aws_sns_topic_subscription" "techno_subscription" {
  topic_arn            = aws_sns_topic.techno_topic.arn
  protocol             = "email"
  endpoint             = "handi@seamolec.org"
}