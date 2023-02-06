#Variable for this file, used to determine when apig changes are made to redeploy the api gateway stage
variable "apiGatewayTerraformFile" {
  default = "./apigateway.tf"
}



#API Gateway config
resource "aws_api_gateway_rest_api" "rest_api" {
  name = local.api_gateway_name
}

resource "aws_api_gateway_resource" "v1" {
      rest_api_id = aws_api_gateway_rest_api.rest_api.id
      parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
      path_part   = "v1"
}

resource "aws_api_gateway_resource" "proxy" {
    rest_api_id = aws_api_gateway_rest_api.rest_api.id
    parent_id   = aws_api_gateway_resource.v1.id
    path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
rest_api_id   = aws_api_gateway_rest_api.rest_api.id
resource_id   = aws_api_gateway_resource.proxy.id
http_method   = "ANY"
authorization = "NONE"

}

resource "aws_api_gateway_integration" "proxy" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.proxy.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:${local.lambda_api_name}/invocations"
}

module "api_gateway_cors_proxy" {
  source = "github.com/kyeotic/terraform-api-gateway-cors-module.git?ref=1.1"
  resource_id = aws_api_gateway_resource.proxy.id
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
}

resource "aws_lambda_permission" "apig_lambda" {
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.proxy_lambda.arn
  principal = "apigateway.amazonaws.com"
  statement_id = "AllowExecutionFromAPIGateway"
  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.rest_api.id}/*/*/*"
}
  
#Stage definition
resource "aws_api_gateway_deployment" "apig_deployment" {
  rest_api_id       = aws_api_gateway_rest_api.rest_api.id
  stage_name        = terraform.workspace
  stage_description = filebase64sha256(var.apiGatewayTerraformFile)

  depends_on = [
                  aws_api_gateway_integration.proxy,
              ]
}


#Display the invoke url in the terminal
output "display_invoke_url" {
  value = "Invoke URL: ${aws_api_gateway_deployment.apig_deployment.invoke_url}"
}

#Display the invoke url in the terminal
output "api_url" {
  value = aws_api_gateway_deployment.apig_deployment.invoke_url
}
