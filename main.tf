resource "aws_securityhub_organization_configuration" "default" {
  auto_enable           = var.auto_enable
  auto_enable_standards = "DEFAULT"
}

resource "aws_securityhub_standards_subscription" "cis_1_2_aws_foundations_benchmark" {
  count = var.enable_cis_1_2 ? 1 : 0

  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
  depends_on    = [aws_securityhub_organization_configuration.default]
}

resource "aws_securityhub_standards_subscription" "cis_1_4_aws_foundations_benchmark" {
  count = var.enable_cis_1_4 ? 1 : 0

  standards_arn = "arn:aws:securityhub:${var.region}::standards/cis-aws-foundations-benchmark/v/1.4.0"
  depends_on    = [aws_securityhub_organization_configuration.default]
}

resource "aws_securityhub_standards_subscription" "best_practices_aws_foundations_benchmark" {
  count = var.enable_best_practices ? 1 : 0

  standards_arn = "arn:aws:securityhub:${var.region}::standards/aws-foundational-security-best-practices/v/1.0.0"
  depends_on    = [aws_securityhub_organization_configuration.default]
}

resource "aws_securityhub_finding_aggregator" "default" {
  linking_mode = "ALL_REGIONS"

  depends_on = [aws_securityhub_organization_configuration.default]
}

resource "aws_securityhub_product_subscription" "default" {
  depends_on = [aws_securityhub_organization_configuration.default]

  for_each    = var.product_arns
  product_arn = each.value
}

resource "aws_securityhub_standards_control" "disabled_rules" {
  for_each = var.disabled_rules

  standards_control_arn = each.value.standards_control_arn
  control_status        = "DISABLED"
  disabled_reason       = each.value.disabled_reason

  depends_on = [
    aws_securityhub_standards_subscription.cis_1_2_aws_foundations_benchmark,
    aws_securityhub_standards_subscription.cis_1_4_aws_foundations_benchmark,
    aws_securityhub_standards_subscription.best_practices_aws_foundations_benchmark,
  ]
}

resource "aws_securityhub_action_target" "default" {
  for_each = var.action_targets

  name        = each.value.name
  identifier  = each.value.identifier
  description = each.value.description

  depends_on = [aws_securityhub_organization_configuration.default]
}

data "aws_organizations_organizational_unit_descendant_accounts" "default" {
  for_each = var.enable_for_organizational_units

  parent_id = each.value
}

resource "aws_securityhub_member" "default" {
  for_each =  {
    for account in flatten([
      for key, descendants in data.aws_organizations_organizational_unit_descendant_accounts.default : [
        for descendant in descendants : descendant
      ]
    ]) account.id => account
  }

  account_id = each.value.id
  email      = try(each.value.email, null)
  invite     = true

  depends_on = [aws_securityhub_organization_configuration.default]
}
