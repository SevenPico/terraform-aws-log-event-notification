resource "aws_cloudwatch_log_group" "log_group_1" {
  #checkov:skip=CKV_AWS_338: "Ensure CloudWatch log groups retains logs for at least 1 year"
  #checkov:skip=CKV_AWS_158: "Ensure that CloudWatch Log Group is encrypted by KMS"

  count             = module.context.enabled ? 1 : 0
  name              = "/aws/example/${module.context.id}/abc"
  retention_in_days = 7

  tags = module.context.tags
}

resource "aws_cloudwatch_log_group" "log_group_2" {
  #checkov:skip=CKV_AWS_338: "Ensure CloudWatch log groups retains logs for at least 1 year"
  #checkov:skip=CKV_AWS_158: "Ensure that CloudWatch Log Group is encrypted by KMS"

  count             = module.context.enabled ? 1 : 0
  name              = "/aws/example/${module.context.id}/efg"
  retention_in_days = 7

  tags = module.context.tags
}

resource "aws_cloudwatch_log_group" "log_group_3" {
  #checkov:skip=CKV_AWS_338: "Ensure CloudWatch log groups retains logs for at least 1 year"
  #checkov:skip=CKV_AWS_158: "Ensure that CloudWatch Log Group is encrypted by KMS"

  count             = module.context.enabled ? 1 : 0
  name              = "/aws/example/${module.context.id}/hij"
  retention_in_days = 7
  tags              = module.context.tags
}

