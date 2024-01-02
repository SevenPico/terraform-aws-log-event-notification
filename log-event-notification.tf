resource "aws_cloudwatch_log_subscription_filter" "log_group_subscription_filter" {
  for_each        = toset(var.log_group_names)
  name            = "${module.context.id}-log-group-filter"
  log_group_name  = each.key
  filter_pattern  = var.subscription_filter_pattern
  destination_arn = module.lambda.arn
  distribution    = "Random"
}