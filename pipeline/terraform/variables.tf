variable "region" {
  default = "us-west-2"
}
data "aws_caller_identity" "current" {}

provider "aws" {
  region = var.region
}


variable "app_namespace" {
    default = "bkk-serial-number-recognizer"
    
}
variable "lambda_api_file" {
    default = "../../build/lambda.zip"
    
}
variable "api_variables" {
    type = map
  default = {
          dev = { stage = "__WORKSPACE__", BUCKETNAME = "lpar"}
          prod = { stage = "__WORKSPACE__",BUCKETNAME = "lpar" }
          default = { stage = "__WORKSPACE__",BUCKETNAME = "lpar" }
          uat = { stage = "__WORKSPACE__", BUCKETNAME= "lpar"}

  }
    
}

locals {
      basic_lambda_role_name = "${var.app_namespace}_lambda_role_${terraform.workspace}"
      basic_lambda_policy_name = "${var.app_namespace}_lambda_policy_${terraform.workspace}"
      api_gateway_name = "${var.app_namespace}_${terraform.workspace}"
      lambda_api_name = "${var.app_namespace}_${terraform.workspace}"
      api_key = "${var.app_namespace}_apikey_${terraform.workspace}"

  }

