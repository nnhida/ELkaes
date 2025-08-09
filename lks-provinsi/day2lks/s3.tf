resource "aws_s3_bucket" "technoinput_malang_hida" {
  bucket = "technoinput-malang-hida"

  tags = {
    Name = "technoinput-malang-hida"
  }
}

resource "aws_s3_bucket" "technooutput_malang_hida" {
  bucket = "technooutput-malang-hida"

  tags = {
    Name = "technooutput-malang-hida"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_input" {
  bucket = aws_s3_bucket.technoinput_malang_hida.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_public_access_block" "block_public_output" {
  bucket = aws_s3_bucket.technooutput_malang_hida.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "policy1" {
  bucket = aws_s3_bucket.technoinput_malang_hida.id
  policy = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::technoinput-malang-hida/*"
            ]
        }
    ]
}
  )
}

resource "aws_s3_bucket_policy" "policy2" {
  bucket = aws_s3_bucket.technooutput_malang_hida.id
  policy = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::technooutput-malang-hida/*"
            ]
        }
    ]
}
  )
}

resource "aws_s3_bucket_lifecycle_configuration" "techno_lifecycle_input" {
  bucket = aws_s3_bucket.technoinput_malang_hida.id

  rule {
    id = "rule-1"

    expiration {
      days = 365
    }

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "techno_lifecycle_output" {
  bucket = aws_s3_bucket.technooutput_malang_hida.id

  rule {
    id = "rule-1"

    expiration {
      days = 365
    }

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    status = "Enabled"
  }
}