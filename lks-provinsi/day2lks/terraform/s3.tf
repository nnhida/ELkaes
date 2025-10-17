resource "aws_s3_bucket" "technoinput_hida" {
  bucket = "technoinput-hida"

  tags = {
    Name = "technoinput-hida"
  }
}

resource "aws_s3_bucket" "technooutput_hida" {
  bucket = "technooutput-hida"

  tags = {
    Name = "technooutput-hida"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_input" {
  bucket = aws_s3_bucket.technoinput_hida.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_public_access_block" "block_public_output" {
  bucket = aws_s3_bucket.technooutput_hida.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "policy1" {
  bucket = aws_s3_bucket.technoinput_hida.id
  depends_on = [aws_s3_bucket_public_access_block.block_public_input]

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicReadGetObject",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::technoinput-hida/*"
      },
      {
        "Sid" : "AllowLambdaReadAccess",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::641191776011:role/LabRole"
        },
        "Action" : [
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::technoinput-hida",
          "arn:aws:s3:::technoinput-hida/*"
        ]
      },
      {
        "Sid" : "AllowRekognitionAccess",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "rekognition.amazonaws.com"
        },
        "Action" : [
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::technoinput-hida",
          "arn:aws:s3:::technoinput-hida/*"
        ]
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "policy2" {
  bucket     = aws_s3_bucket.technooutput_hida.id
  depends_on = [aws_s3_bucket_public_access_block.block_public_output]

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowLambdaWriteAccess",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::641191776011:role/LabRole"
        },
        "Action" : ["s3:PutObject", "s3:PutObjectAcl"],
        "Resource" : "arn:aws:s3:::technooutput-hida/*"
      }
    ]
  })
}

resource "aws_s3_bucket_lifecycle_configuration" "techno_lifecycle_input" {
  bucket = aws_s3_bucket.technoinput_hida.id

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
  bucket = aws_s3_bucket.technooutput_hida.id

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
