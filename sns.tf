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