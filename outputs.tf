output "disabled_rules" {
  value = aws_securityhub_standards_control.disabled_rules
}

output "action_targets" {
  value = aws_securityhub_action_target.default
}

output "product_subscriptions" {
  value = aws_securityhub_product_subscription.default
}
