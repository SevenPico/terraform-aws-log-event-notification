#------------------------------------------------------------------------------
# ChatBot Role
#------------------------------------------------------------------------------
module "chatbot_role" {
  source     = "SevenPicoForks/iam-role/aws"
  version    = "2.0.1"
  context    = module.context.self
  enabled    = module.context.enabled && var.enable_slack_chatbot
  attributes = ["chatbot", "service", "role"]

  role_description         = "AWS ChatBot Assume role"
  assume_role_actions      = ["sts:AssumeRole"]
  assume_role_conditions   = []
  instance_profile_enabled = false
  managed_policy_arns      = []
  permissions_boundary     = ""
  policy_description       = ""
  policy_document_count    = 0
  policy_documents         = []
  principals = {
    "Service" : ["chatbot.amazonaws.com"]
  }
  path         = "/"
  use_fullname = true
  tenant       = ""
}


#------------------------------------------------------------------------------
# ChatBot
#------------------------------------------------------------------------------
resource "awscc_chatbot_slack_channel_configuration" "chatbot_slack" {
  count              = module.context.enabled && var.enable_slack_chatbot ? 1 : 0
  configuration_name = "${module.context.id}-log-events-notification"
  guardrail_policies = []
  iam_role_arn       = module.chatbot_role.arn
  logging_level      = "NONE"
  slack_channel_id   = var.slack_channel_id
  slack_workspace_id = var.slack_workspace_id
  sns_topic_arns = [
    module.sns_warn.topic_arn,
    module.sns_info.topic_arn,
    module.sns_error.topic_arn
  ]
  user_role_required = false
}