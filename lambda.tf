#------------------------------------------------------------------------------
# Lambda Function
#------------------------------------------------------------------------------
data "archive_file" "lambda_zip" {
  count       = module.context.enabled ? 1 : 0
  type        = "zip"
  source_dir  = "${path.module}/lambda/log-to-notification-transformer"
  output_path = "${path.module}/lambda/log-to-notification-transformer.zip"
}

module "lambda" {
  source  = "registry.terraform.io/SevenPicoForks/lambda-function/aws"
  version = "2.0.3"
  context = module.context.self

  architectures                       = null
  cloudwatch_event_rules              = {}
  cloudwatch_lambda_insights_enabled  = false
  cloudwatch_logs_kms_key_arn         = ""
  cloudwatch_logs_retention_in_days   = 90
  cloudwatch_log_subscription_filters = {}
  description                         = "Lambda function to send custom message to Sns"
  event_source_mappings               = {}
  filename                            = data.archive_file.lambda_zip[0].output_path
  source_code_hash                    = filebase64sha256(data.archive_file.lambda_zip[0].output_path)
  file_system_config                  = null
  function_name                       = "LogToNotificationTransformer"
  handler                             = "index.handler"
  ignore_external_function_updates    = false
  image_config                        = {}
  image_uri                           = null
  kms_key_arn                         = ""
  lambda_at_edge                      = false
  lambda_environment = {
    variables = {
      REGION : local.region
      ERROR_SNS_TOPIC_ARN : module.sns_error.topic_arn
      INFO_SNS_TOPIC_ARN : module.sns_info.topic_arn
      WARN_SNS_TOPIC_ARN : module.sns_warn.topic_arn
      ACCOUNT_NUMBER : local.account_id
      DEPLOYMENT_ENVIRONMENT : module.context.environment
    }
  }
  lambda_role_source_policy_documents = []
  layers                              = []
  memory_size                         = 512
  package_type                        = "Zip"
  publish                             = false
  reserved_concurrent_executions      = -1
  role_name                           = "${module.context.id}-lambda-role"
  runtime                             = "nodejs18.x"
  s3_bucket                           = null
  s3_key                              = null
  s3_object_version                   = null
  sns_subscriptions                   = {}
  ssm_parameter_names                 = null
  timeout                             = 300
  tracing_config_mode                 = null
  vpc_config                          = null
}

resource "aws_lambda_permission" "subscription_filter_log_events_permission" {
  statement_id  = "AllowExecutionFromCloudWatchLogs"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.function_name
  principal     = "logs.amazonaws.com"
  source_arn    = "${local.arn_prefix}:logs:${local.region}:${local.account_id}:log-group:*:*"
}

