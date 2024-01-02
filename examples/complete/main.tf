module "log_event_notification" {
  source                      = "../../"
  subscription_filter_pattern = "%\\] ERROR \\[|] INFO \\[|] WARN \\[%"
  log_group_arns = [
    aws_cloudwatch_log_group.log_group_1[0].arn,
    aws_cloudwatch_log_group.log_group_2[0].arn,
    aws_cloudwatch_log_group.log_group_3[0].arn
  ]
  enable_slack_chatbot = true
  slack_workspace_id   = ""
  slack_channel_id     = ""
}