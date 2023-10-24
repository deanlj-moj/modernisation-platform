locals {
  root_account                 = data.aws_organizations_organization.root_account
  collaborators                = jsondecode(file("../../collaborators.json"))
  environment_management       = jsondecode(data.aws_secretsmanager_secret_version.environment_management.secret_string)
  environments                 = [for file in fileset("../../environments", "*.json") : replace(file, ".json", "")]
  modernisation_platform_ou_id = local.environment_management.modernisation_platform_organisation_unit_id
  pagerduty_integration_keys   = jsondecode(data.aws_secretsmanager_secret_version.pagerduty_integration_keys.secret_string)

  root_users_with_state_access = [ # also includes the organisational GHA Role
    "arn:aws:iam::${local.root_account.master_account_id}:user/ModernisationPlatformOrganisationManagement",
    "arn:aws:iam::${local.root_account.master_account_id}:user/DavidElliott",
    "arn:aws:iam::${local.root_account.master_account_id}:role/ModernisationPlatformGithubActionsRole" # Role with the same permissions as ModernisationPlatformOrganisationManagement for Github OIDC
  ]

  environment_accounts = {
    for env in local.environments :
    env => [for k, v in local.environment_management.account_ids : v if length(regexall("^${env}-", k)) > 0]
  }

  tags = {
    business-unit = "Platforms"
    application   = "Modernisation Platform"
    is-production = true
    owner         = "Modernisation Platform: modernisation-platform@digital.justice.gov.uk"
  }
}
