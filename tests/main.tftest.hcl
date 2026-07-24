mock_provider "aws" {}

run "plan" {
  command = plan
  variables {
    region = "eu-central-1"
    # the ALL_REGIONS default trips a provider min-items validation via the
    # always-true linked_regions condition in main.tf
    linked_regions = {
      type    = "SPECIFIED_REGIONS"
      regions = ["eu-west-1"]
    }
  }
}
