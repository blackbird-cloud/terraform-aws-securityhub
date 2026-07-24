<!-- BEGIN_TF_DOCS -->
# Terraform Aws Securityhub Module
Terraform module to create an AWS Security Hub

[![blackbird-logo](https://raw.githubusercontent.com/blackbird-cloud/terraform-module-template/main/.config/logo_simple.png)](https://blackbird.cloud)

## Example
```hcl
module "securityhub" {
  source  = "blackbird-cloud/securityhub/aws"
  version = "~> 2.0"

  region = "eu-central-1"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |

## Resources

| Name | Type |
|------|------|
| [aws_securityhub_action_target.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_action_target) | resource |
| [aws_securityhub_configuration_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_configuration_policy) | resource |
| [aws_securityhub_configuration_policy_association.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_configuration_policy_association) | resource |
| [aws_securityhub_finding_aggregator.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_finding_aggregator) | resource |
| [aws_securityhub_organization_configuration.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_organization_configuration) | resource |
| [aws_securityhub_product_subscription.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_product_subscription) | resource |
| [aws_securityhub_standards_control.disabled_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_standards_control) | resource |
| [aws_securityhub_standards_subscription.best_practices_aws_foundations_benchmark](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_standards_subscription) | resource |
| [aws_securityhub_standards_subscription.cis_1_2_aws_foundations_benchmark](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_standards_subscription) | resource |
| [aws_securityhub_standards_subscription.cis_1_4_aws_foundations_benchmark](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_standards_subscription) | resource |
| [aws_securityhub_standards_subscription.cis_3_0_aws_foundations_benchmark](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_standards_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action_targets"></a> [action\_targets](#input\_action\_targets) | Map of action targets to configure, configures AWS Security Hub to send selected insights and findings to Amazon EventBridge. | <pre>map(object({<br/>    name        = string<br/>    identifier  = string<br/>    description = string<br/>  }))</pre> | `{}` | no |
| <a name="input_auto_enable"></a> [auto\_enable](#input\_auto\_enable) | (Optional) Whether to automatically enable Security Hub for new accounts in the organization. Defaults to false. | `bool` | `true` | no |
| <a name="input_auto_enable_standards"></a> [auto\_enable\_standards](#input\_auto\_enable\_standards) | (Optional) Whether to automatically enable Security Hub default standards for new member accounts in the organization. By default, this parameter is equal to DEFAULT, and new member accounts are automatically enabled with default Security Hub standards. To opt out of enabling default standards for new member accounts, set this parameter equal to NONE. | `string` | `"DEFAULT"` | no |
| <a name="input_central_config"></a> [central\_config](#input\_central\_config) | Central Security Hub configuration for the organization. | <pre>object({<br/>    enabled = bool<br/>    policies = map(object({<br/>      ous               = optional(map(string))<br/>      disabled_controls = optional(list(string))<br/>      enabled_controls  = optional(list(string))<br/>    }))<br/>  })</pre> | <pre>{<br/>  "enabled": false,<br/>  "policies": {}<br/>}</pre> | no |
| <a name="input_disabled_rules"></a> [disabled\_rules](#input\_disabled\_rules) | Map of rules to disable from the enabled standards. | <pre>map(object({<br/>    standards_control_arn = string<br/>    disabled_reason       = string<br/>  }))</pre> | `{}` | no |
| <a name="input_enable_best_practices"></a> [enable\_best\_practices](#input\_enable\_best\_practices) | Whether to enable the AWS Foundational Security Best Practices standards subscription. | `bool` | `true` | no |
| <a name="input_enable_cis_1_2"></a> [enable\_cis\_1\_2](#input\_enable\_cis\_1\_2) | Whether to enable the CIS AWS Foundations Benchmark v1.2.0 standards subscription. If you want to disable this, on first deploy leave it enabled, then disable it. | `bool` | `true` | no |
| <a name="input_enable_cis_1_4"></a> [enable\_cis\_1\_4](#input\_enable\_cis\_1\_4) | Whether to enable the CIS AWS Foundations Benchmark v1.4.0 standards subscription. | `bool` | `false` | no |
| <a name="input_enable_cis_3_0"></a> [enable\_cis\_3\_0](#input\_enable\_cis\_3\_0) | Whether to enable the CIS AWS Foundations Benchmark v3.0.0 standards subscription. | `bool` | `false` | no |
| <a name="input_linked_regions"></a> [linked\_regions](#input\_linked\_regions) | List of regions to enable Security Hub in. | <pre>object({<br/>    type    = string<br/>    regions = optional(list(string))<br/>  })</pre> | <pre>{<br/>  "regions": [],<br/>  "type": "ALL_REGIONS"<br/>}</pre> | no |
| <a name="input_product_arns"></a> [product\_arns](#input\_product\_arns) | (Optional) Map of production name : product arn. The ARN of the product that generates findings that you want to import into Security Hub. | `map(string)` | `{}` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region used for picking up the ARNs for the securityhub standards subscriptions. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_action_targets"></a> [action\_targets](#output\_action\_targets) | Map of action targets, AWS Security Hub to send selected insights and findings to Amazon EventBridge. |
| <a name="output_aws_securityhub_configuration_policy"></a> [aws\_securityhub\_configuration\_policy](#output\_aws\_securityhub\_configuration\_policy) | AWS Security Hub Configuration Policy |
| <a name="output_aws_securityhubaws_securityhub_organization_configuration_config"></a> [aws\_securityhubaws\_securityhub\_organization\_configuration\_config](#output\_aws\_securityhubaws\_securityhub\_organization\_configuration\_config) | AWS Security Hub Organization Configuration |
| <a name="output_disabled_rules"></a> [disabled\_rules](#output\_disabled\_rules) | Map of rules to disable from the enabled standards. |
| <a name="output_product_subscriptions"></a> [product\_subscriptions](#output\_product\_subscriptions) | Map of product subscriptions, the ARN of the product that generates findings that you want to import into Security Hub. |

## About

We are [Blackbird Cloud](https://blackbird.cloud), Amsterdam based cloud consultancy, and cloud management service provider. We help companies build secure, cost efficient, and scale-able solutions.

Checkout our other :point\_right: [terraform modules](https://registry.terraform.io/namespaces/blackbird-cloud)

## Copyright

Copyright © 2017-2026 [Blackbird Cloud](https://blackbird.cloud)
<!-- END_TF_DOCS -->