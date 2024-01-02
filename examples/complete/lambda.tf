##------------------------------------------------------------------------------
## Lambda Context
##------------------------------------------------------------------------------
#module "lambda_context" {
#  source     = "SevenPico/context/null"
#  version    = "2.0.0"
#  context    = module.context.self
#  enabled    = module.context.enabled
#  attributes = ["noise", "generator", "lambda"]
#}
#
#
##------------------------------------------------------------------------------
## Lambda Function
##------------------------------------------------------------------------------
#data "archive_file" "lambda_zip" {
#  count       = module.context.enabled ? 1 : 0
#  type        = "zip"
#  source_dir  = "${path.module}/lambda/logs-noise-generator"
#  output_path = "${path.module}/lambda/logs-noise-generator.zip"
#}
#
#
#module "lambda" {
#  source  = "registry.terraform.io/SevenPicoForks/lambda-function/aws"
#  version = "2.0.3"
#  context = module.lambda_context.self
#
#  architectures                       = null
#  cloudwatch_event_rules              = {}
#  cloudwatch_lambda_insights_enabled  = false
#  cloudwatch_logs_kms_key_arn         = ""
#  cloudwatch_logs_retention_in_days   = 90
#  cloudwatch_log_subscription_filters = {}
#  description                         = "Lambda function to generate logs"
#  event_source_mappings               = {}
#  filename                            = data.archive_file.lambda_zip[0].output_path
#  source_code_hash                    = filebase64sha256(data.archive_file.lambda_zip[0].output_path)
#  file_system_config                  = null
#  function_name                       = module.context.id
#  handler                             = "index.lambda_handler"
#  ignore_external_function_updates    = false
#  image_config                        = {}
#  image_uri                           = null
#  kms_key_arn                         = ""
#  lambda_at_edge                      = false
#  lambda_environment = {
#    variables = {
#    }
#  }
#  lambda_role_source_policy_documents = []
#  layers                              = []
#  memory_size                         = 512
#  package_type                        = "Zip"
#  publish                             = false
#  reserved_concurrent_executions      = -1
#  role_name                           = "${module.context.id}-lambda-role"
#  runtime                             = "python3.9"
#  s3_bucket                           = null
#  s3_key                              = null
#  s3_object_version                   = null
#  sns_subscriptions                   = {}
#  ssm_parameter_names                 = null
#  timeout                             = 300
#  tracing_config_mode                 = null
#  vpc_config                          = null
#}
#
