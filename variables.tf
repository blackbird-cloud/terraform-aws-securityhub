variable "auto_enable" {
  type        = bool
  default     = true
  description = "(Optional) Whether to automatically enable Security Hub for new accounts in the organization. Defaults to false."
}

variable "auto_enable_standards" {
  type        = string
  description = "(Optional) Whether to automatically enable Security Hub default standards for new member accounts in the organization. By default, this parameter is equal to DEFAULT, and new member accounts are automatically enabled with default Security Hub standards. To opt out of enabling default standards for new member accounts, set this parameter equal to NONE."
  default     = "DEFAULT"
}

variable "region" {
  type        = string
  description = "AWS Region used for picking up the ARNs for the securityhub standards subscriptions."
}

variable "enable_cis_1_2" {
  type        = bool
  default     = true
  description = "Whether to enable the CIS AWS Foundations Benchmark v1.2.0 standards subscription. If you want to disable this, on first deploy leave it enabled, then disable it."
}

variable "enable_cis_1_4" {
  type        = bool
  default     = true
  description = "Whether to enable the CIS AWS Foundations Benchmark v1.4.0 standards subscription."
}

variable "enable_best_practices" {
  type        = bool
  default     = true
  description = "Whether to enable the AWS Foundational Security Best Practices standards subscription."
}

variable "product_arns" {
  type        = map(string)
  default     = {}
  description = "(Optional) Map of production name : product arn. The ARN of the product that generates findings that you want to import into Security Hub."
}

variable "disabled_rules" {
  type = map(object({
    standards_control_arn = string
    disabled_reason       = string
  }))
  default     = {}
  description = "Map of rules to disable from the enabled standards."
}

variable "action_targets" {
  type = map(object({
    name        = string
    identifier  = string
    description = string
  }))
  default     = {}
  description = "Map of action targets to configure, configures AWS Security Hub to send selected insights and findings to Amazon EventBridge."
}
