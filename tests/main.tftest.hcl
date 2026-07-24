mock_provider "aws" {}

run "plan" {
  command = plan
  variables {
    region = "eu-central-1"
  }
}

run "plan_specified_regions" {
  command = plan
  variables {
    region = "eu-central-1"
    linked_regions = {
      type    = "SPECIFIED_REGIONS"
      regions = ["eu-west-1"]
    }
  }
}
