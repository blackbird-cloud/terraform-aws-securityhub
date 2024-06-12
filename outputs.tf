output "disabled_rules" {
  value       = aws_securityhub_standards_control.disabled_rules
  description = "Map of rules to disable from the enabled standards."
}

output "action_targets" {
  value       = aws_securityhub_action_target.default
  description = "Map of action targets, AWS Security Hub to send selected insights and findings to Amazon EventBridge."
}

output "product_subscriptions" {
  value       = aws_securityhub_product_subscription.default
  description = "Map of product subscriptions, the ARN of the product that generates findings that you want to import into Security Hub."
}

output "aws_securityhubaws_securityhub_organization_configuration_config" {
  value       = aws_securityhub_organization_configuration.default
  description = "AWS Security Hub Organization Configuration"
}

output "aws_securityhub_configuration_policy" {
  value       = aws_securityhub_configuration_policy.default[0]
  description = "AWS Security Hub Configuration Policy"
}
