#------------------------------------------------------------------------------
# Sns Context
#------------------------------------------------------------------------------
module "sns_context" {
  source     = "SevenPico/context/null"
  version    = "2.0.0"
  context    = module.context.self
  enabled    = module.context.enabled
  attributes = ["sns"]
}


#------------------------------------------------------------------------------
# Sns Kms Key
#------------------------------------------------------------------------------
module "sns_kms_key" {
  source                   = "SevenPicoForks/kms-key/aws"
  version                  = "2.0.0"
  context                  = module.sns_context.self
  alias                    = ""
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  deletion_window_in_days  = 30
  enable_key_rotation      = true
  key_usage                = "ENCRYPT_DECRYPT"
  multi_region             = false
}


#------------------------------------------------------------------------------
# Sns
#------------------------------------------------------------------------------
module "sns_error" {
  source            = "SevenPico/sns/aws"
  version           = "2.0.2"
  context           = module.sns_context.self
  attributes        = ["error"]
  kms_master_key_id = module.sns_kms_key.key_id
  pub_principals    = {}
  sub_principals    = {}
}

module "sns_warn" {
  source            = "SevenPico/sns/aws"
  version           = "2.0.2"
  context           = module.sns_context.self
  attributes        = ["warn"]
  kms_master_key_id = module.sns_kms_key.key_id
  pub_principals    = {}
  sub_principals    = {}
}

module "sns_info" {
  source            = "SevenPico/sns/aws"
  version           = "2.0.2"
  context           = module.sns_context.self
  attributes        = ["info"]
  kms_master_key_id = module.sns_kms_key.key_id
  pub_principals    = {}
  sub_principals    = {}
}

data "aws_iam_policy_document" "lambda_role_policy_doc" {
  count = module.context.enabled ? 1 : 0

  policy_id = module.context.id

  statement {
    sid     = "AllowPub"
    effect  = "Allow"
    actions = ["SNS:Publish"]
    resources = [
      module.sns_error.topic_arn,
      module.sns_warn.topic_arn,
      module.sns_info.topic_arn
    ]
  }
  statement {
    sid     = "AllowPub"
    effect  = "Allow"
    actions = ["kms:GenerateDataKey","kms:Decrypt",]
    resources = [
      module.sns_kms_key.key_arn
    ]
  }
}

resource "aws_iam_policy" "lambda_role_policy" {
  count       = module.context.enabled ? 1 : 0
  name        = "${module.context.id}-sns-permission-policy"
  description = "Permission To Allow Lambda to Publish To Sns."
  policy      = data.aws_iam_policy_document.lambda_role_policy_doc[0].json
}

resource "aws_iam_policy_attachment" "lambda_role_policy_attachment" {
  count      = module.context.enabled ? 1 : 0
  name       = "${module.context.id}-sns-permission-policy-attachment"
  roles      = ["${module.context.id}-lambda-role"]
  policy_arn = aws_iam_policy.lambda_role_policy[0].arn
}


