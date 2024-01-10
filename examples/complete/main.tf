module "log_event_notification" {
  source                      = "../../"
  context                     = module.context.self

  subscription_filter_pattern = "%ERROR|INFO|WARN%"
  log_group_names = [
    try(aws_cloudwatch_log_group.log_group_1[0].name, ""),
    try(aws_cloudwatch_log_group.log_group_2[0].name, ""),
    try(aws_cloudwatch_log_group.log_group_3[0].name, "")
  ]
  enable_slack_chatbot = true
  slack_workspace_id   = var.slack_workspace_id # Required when enable_slack_chatbot = true
  slack_channel_id     = var.slack_channel_id   # Required when enable_slack_chatbot = true
}