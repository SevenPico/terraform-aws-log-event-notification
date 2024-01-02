variable "log_group_arns" {
  type        = list(string)
  default     = []
  description = "List of all Log group arns for subscription filter needs to be created."
}

variable "subscription_filter_pattern" {
  type        = string
  description = "(Required) Log Group Filter Pattern."
}

variable "enable_slack_chatbot" {
  type        = bool
  default     = true
  description = "To enable chatbot for slack."
}

variable "slack_workspace_id" {
  type        = string
  description = "The id of the Slack workspace."
}

variable "slack_channel_id" {
  default = "The id of the Slack channel."
}