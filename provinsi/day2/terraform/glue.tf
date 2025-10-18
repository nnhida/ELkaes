resource "aws_glue_catalog_database" "rekognition_results_db" {
  name         = "rekognition_results_db"
  location_uri = "s3://${aws_s3_bucket.technooutput_hida.bucket}/"
}

resource "aws_glue_catalog_table" "rekognition_results_table" {
  name          = "rekognition_results_table"
  database_name = aws_glue_catalog_database.rekognition_results_db.name
  table_type    = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.technooutput_hida.bucket}/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "json-serde"
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
    }

    columns {
      name = "image_key"
      type = "string"
    }

    columns {
      name = "labels"
      type = "array<struct<Name:string,Confidence:double>>"
    }
  }
}

resource "aws_glue_crawler" "techno_crawler_hida" {
  database_name = aws_glue_catalog_database.rekognition_results_db.name
  name          = "techno-crawler-hida"
  role          = "arn:aws:iam::641191776011:role/LabRole"

  s3_target {
    path = "s3://${aws_s3_bucket.technooutput_hida.bucket}"
  }
}