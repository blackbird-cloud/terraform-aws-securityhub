module "securithub" {
  # source = "blackbird-cloud/securithub/aws"
  source = "../"
  # version = ">= 2"

  region                = "eu-central-1"
  auto_enable           = false
  auto_enable_standards = "NONE"

  enable_cis_1_2 = false
  enable_cis_1_4 = false
  enable_cis_3_0 = true
  linked_regions = {
    type = "ALL_REGIONS"
  }
  central_config = {
    enabled = true
    policies = {
      workloads = {
        enabled = true
        ous = {
          my-ou = "my-ou"
        }
        disabled_controls = [
          "IAM.6",  // root Hardware MFA
          "IAM.9",  // root virtual MFA
          "IAM.18", // AWS Support IAM role
          "S3.20"   // MFA requirement to delete objects
        ]
        security_control_custom_parameters = [
          {
            security_control_id = "CONFIG.1"
            parameters = [
              {
                name       = "includeConfigServiceLinkedRoleCheck"
                value_type = "CUSTOM"
                bool       = false
              }
            ]
          },
          {
            security_control_id = "S3.20"
            parameters = [
              {
                name       = "MFADelete"
                value_type = "CUSTOM"
                enum_list  = ["ENABLED", "DISABLED"]
              }
            ]
          }
        ]
      }
    }
  }
}
