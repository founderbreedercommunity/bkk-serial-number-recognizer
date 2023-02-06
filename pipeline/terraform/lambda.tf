##
# Lambda functions
##

resource "aws_lambda_function" "proxy_lambda" {
  filename = var.lambda_api_file
  function_name = local.lambda_api_name
  handler = "api.handler"
  timeout = 30
  memory_size = 1044
  role = aws_iam_role.lambda_execution_role.arn
  runtime = "nodejs12.x"
  source_code_hash = filebase64sha256(var.lambda_api_file)
  environment {
    variables = var.api_variables[contains(keys(var.api_variables), terraform.workspace) ? terraform.workspace : "default"] 
  }
  
}
##
# aws lambda layer
##
#resource "aws_lambda_layer_version" "oraclelib" {
#  filename = "../../oraclelib/clientlib.zip"
#  layer_name = "oraclelib"
#}
