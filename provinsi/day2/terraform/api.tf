resource "aws_api_gateway_rest_api" "techno_api_hida" {
  name = "Techno-API-Hida"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    Name = "Techno-API-Hida"
  }
}

resource "aws_api_gateway_resource" "generate_token" {
  rest_api_id = aws_api_gateway_rest_api.techno_api_hida.id
  parent_id   = aws_api_gateway_rest_api.techno_api_hida.root_resource_id
  path_part   = "generate-token"
}

resource "aws_api_gateway_method" "generate_token_methods" {
  rest_api_id   = aws_api_gateway_rest_api.techno_api_hida.id
  resource_id   = aws_api_gateway_resource.generate_token.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "generate_tokenintegration" {
  rest_api_id             = aws_api_gateway_rest_api.techno_api_hida.id
  resource_id             = aws_api_gateway_resource.generate_token.id
  http_method             = aws_api_gateway_method.generate_token_methods.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:641191776011:function:techno-lambda-post/invocations"
}

resource "aws_api_gateway_resource" "validate_token" {
  rest_api_id = aws_api_gateway_rest_api.techno_api_hida.id
  parent_id   = aws_api_gateway_rest_api.techno_api_hida.root_resource_id
  path_part   = "validate-token"
}

resource "aws_api_gateway_method" "validate_token_methods" {
  rest_api_id   = aws_api_gateway_rest_api.techno_api_hida.id
  resource_id   = aws_api_gateway_resource.validate_token.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "validate_tokenintegration" {
  rest_api_id             = aws_api_gateway_rest_api.techno_api_hida.id
  resource_id             = aws_api_gateway_resource.validate_token.id
  http_method             = aws_api_gateway_method.validate_token_methods.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:641191776011:function:techno-lambda-get/invocations"
}

resource "aws_api_gateway_deployment" "techno_api_deploy" {
  depends_on = [
    aws_api_gateway_integration.generate_tokenintegration,
    aws_api_gateway_integration.validate_tokenintegration
  ]

  rest_api_id = aws_api_gateway_rest_api.techno_api_hida.id
}

resource "aws_api_gateway_stage" "techno_api_stage" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.techno_api_hida.id
  deployment_id = aws_api_gateway_deployment.techno_api_deploy.id
}