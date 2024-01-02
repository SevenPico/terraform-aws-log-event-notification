resource "aws_cloudwatch_log_group" "log_group_1" {
  count = module.context.enabled ? 1 : 0
  name = "/aws/example/${module.context.id}/abc}"

  tags = module.context.tags
}

resource "aws_cloudwatch_log_group" "log_group_2" {
  count = module.context.enabled ? 1 : 0
  name = "/aws/example/${module.context.id}/efg}"

  tags = module.context.tags
}

resource "aws_cloudwatch_log_group" "log_group_3" {
  count = module.context.enabled ? 1 : 0
  name = "/aws/example/${module.context.id}/hij"

  tags = module.context.tags
}

