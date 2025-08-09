resource "aws_glue_catalog_database" "rekognition_results_db" {
  name = "rekognition_results_db"
}

resource "aws_glue_catalog_table" "rekognition_results_table" {
  name          = "rekognition_results_table"
  database_name = "rekognition_results_db"
}

resource "aws_glue_crawler" "techno_crawler_hida" {
  database_name = aws_glue_catalog_database.rekognition_results_db.name
  name          = "techno-crawler-hida"
  role          = "arn:aws:iam::684066883616:role/LabRole"

  s3_target {
    path = "s3://${aws_s3_bucket.technooutput_malang_hida.bucket}"
  }
}