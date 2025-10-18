resource "aws_sns_topic" "techno_topic" {
  name = "techno-sns"
}

resource "aws_sns_topic_subscription" "techno_subscription" {
  topic_arn            = aws_sns_topic.techno_topic.arn
  protocol             = "email"
  endpoint             = "nurhidayahayundira296@gmail.com"
}