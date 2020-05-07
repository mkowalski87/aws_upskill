provider "aws" {
  region = "eu-central-1"
  profile = "aws-upskill"
}

# Variables
variable "aws_region" {
  default = "eu-central-1"
}

variable "aws_account" {
  default = "******"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

module "lambda_search_items" {
  source = "./lambda_module"
  name = "search_items"
  role = "${aws_iam_role.iam_for_lambda.arn}"
}

module "lambda_get_locations_for_item" {
  source = "./lambda_module"
  name = "get_locations_for_item"
  role = "${aws_iam_role.iam_for_lambda.arn}"
}

resource "aws_api_gateway_rest_api" "warehouse_api" {
  name = "warehouse-api"
  description = "APi for warehouse module created by terraform"
}

resource "aws_api_gateway_resource" "warehouse_api_resource" {
  path_part = "warehouse"
  parent_id = "${aws_api_gateway_rest_api.warehouse_api.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.warehouse_api.id}"
}

module "get_serch_items" {
  source      = "./api_gateway"
  rest_api_id = "${aws_api_gateway_rest_api.warehouse_api.id}"
  resource_id = "${aws_api_gateway_resource.warehouse_api_resource.id}"
  method      = "GET"
  path        = "${aws_api_gateway_resource.warehouse_api_resource.path}"
  lambda      = "${module.lambda_search_items.name}"
  region      = "${var.aws_region}"
  account_id  = "${var.aws_account}"
}

module "get_locations_for_item" {
  source      = "./api_gateway"
  rest_api_id = "${aws_api_gateway_rest_api.warehouse_api.id}"
  resource_id = "${aws_api_gateway_resource.warehouse_api_resource.id}"
  method      = "GET"
  path        = "${aws_api_gateway_resource.warehouse_api_resource.path}"
  lambda      = "${module.lambda_get_locations_for_item.name}"
  region      = "${var.aws_region}"
  account_id  = "${var.aws_account}"
}

resource "aws_api_gateway_deployment" "warehouse_api_deployment" {
  depends_on = [module.get_locations_for_item.integration, module.get_serch_items.integration]
  rest_api_id = "${aws_api_gateway_rest_api.warehouse_api.id}"
  stage_name  = "live"
}