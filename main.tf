# Organization Configuration
resource "aws_securityhub_organization_configuration" "default" {
  auto_enable           = var.central_config.enabled ? false : var.auto_enable
  auto_enable_standards = var.central_config.enabled ? "NONE" : var.auto_enable_standards

  organization_configuration {
    configuration_type = var.central_config.enabled ? "CENTRAL" : "LOCAL"
  }

  depends_on = [ aws_securityhub_finding_aggregator.default ]
}

locals {
  cis_1_2_arn        = var.enable_cis_1_2 ? ["arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"] : []
  cis_1_4_arn        = var.enable_cis_1_4 ? ["arn:aws:securityhub:${var.region}::standards/cis-aws-foundations-benchmark/v/1.4.0"] : []
  cis_3_0_arn        = var.enable_cis_3_0 ? ["arn:aws:securityhub:${var.region}::standards/cis-aws-foundations-benchmark/v/3.0.0"] : []
  best_practices_arn = "arn:aws:securityhub:${var.region}::standards/aws-foundational-security-best-practices/v/1.0.0"

  enabled_standards_arns = concat(local.cis_1_2_arn, local.cis_1_4_arn, local.cis_3_0_arn, [local.best_practices_arn])

  policy_ous = flatten([
    for key, policy in var.central_config.policies : [
      for k, ou in policy.ous : {
        policy = key
        ou     = ou
      }
    ]
  ])
}

resource "aws_securityhub_configuration_policy" "default" {
  for_each = var.central_config.enabled ? var.central_config.policies : {}
  name     = "securityhub-organization-configuration-${each.key}"

  configuration_policy {
    service_enabled       = true
    enabled_standard_arns = local.enabled_standards_arns
    security_controls_configuration {
      disabled_control_identifiers = each.value.disabled_controls
      enabled_control_identifiers  = each.value.enabled_controls
    }
  }

  depends_on = [aws_securityhub_organization_configuration.default]
}

resource "aws_securityhub_configuration_policy_association" "default" {
  for_each = var.central_config.enabled ? {
    for each in local.policy_ous : "${each.policy}-${each.ou}" => {
      policy = each.policy
      ou     = each.ou
    }
  } : {}
  target_id = each.value.ou
  policy_id = aws_securityhub_configuration_policy.default[each.value.policy].id

  depends_on = [aws_securityhub_configuration_policy.default]
}

# Single account use
resource "aws_securityhub_standards_subscription" "cis_1_2_aws_foundations_benchmark" {
  count = !var.central_config.enabled && var.enable_cis_1_2 ? 1 : 0

  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
  depends_on    = [aws_securityhub_organization_configuration.default]
}

resource "aws_securityhub_standards_subscription" "cis_1_4_aws_foundations_benchmark" {
  count = !var.central_config.enabled && var.enable_cis_1_4 ? 1 : 0

  standards_arn = "arn:aws:securityhub:${var.region}::standards/cis-aws-foundations-benchmark/v/1.4.0"
  depends_on    = [aws_securityhub_organization_configuration.default]
}

resource "aws_securityhub_standards_subscription" "cis_3_0_aws_foundations_benchmark" {
  count = !var.central_config.enabled && var.enable_cis_3_0 ? 1 : 0

  standards_arn = "arn:aws:securityhub:${var.region}::standards/cis-aws-foundations-benchmark/v/3.0.0"
  depends_on    = [aws_securityhub_organization_configuration.default]
}

resource "aws_securityhub_standards_subscription" "best_practices_aws_foundations_benchmark" {
  count = !var.central_config.enabled && var.enable_best_practices ? 1 : 0

  standards_arn = "arn:aws:securityhub:${var.region}::standards/aws-foundational-security-best-practices/v/1.0.0"
  depends_on    = [aws_securityhub_organization_configuration.default]
}

resource "aws_securityhub_finding_aggregator" "default" {
  count = var.linked_regions.type != "NONE" ? 1 : 0

  linking_mode = var.linked_regions.type

  specified_regions = var.linked_regions.type != "ALL_REGIONS" || var.linked_regions.type != "NONE" ? var.linked_regions.regions : null
}

resource "aws_securityhub_product_subscription" "default" {
  depends_on = [aws_securityhub_organization_configuration.default]

  for_each    = var.product_arns
  product_arn = each.value
}

resource "aws_securityhub_standards_control" "disabled_rules" {
  for_each = var.central_config.enabled ? {} : var.disabled_rules

  standards_control_arn = each.value.standards_control_arn
  control_status        = "DISABLED"
  disabled_reason       = each.value.disabled_reason

  depends_on = [
    aws_securityhub_standards_subscription.cis_1_2_aws_foundations_benchmark,
    aws_securityhub_standards_subscription.cis_1_4_aws_foundations_benchmark,
    aws_securityhub_standards_subscription.cis_3_0_aws_foundations_benchmark,
    aws_securityhub_standards_subscription.best_practices_aws_foundations_benchmark,
  ]
}

# Notifications
resource "aws_securityhub_action_target" "default" {
  for_each = var.action_targets

  name        = each.value.name
  identifier  = each.value.identifier
  description = each.value.description

  depends_on = [aws_securityhub_organization_configuration.default]
}
