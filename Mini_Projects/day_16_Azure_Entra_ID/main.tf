data "azuread_domains" "aad_domains" {
    only_initial = true
}

locals {
    domain_name = data.azuread_domains.aad_domains.domains.*.domain_name
    users = csvdecode(file("${path.module}/users.csv"))
}

resource "azuread_user" "users" {
  for_each = { for user in local.users : format("%s.%s", lower(replace(user.first_name, " ", "")), lower(replace(user.last_name, " ", ""))) => user }

  user_principal_name = format(
    "%s.%s@%s",
    substr(lower(replace(each.value.first_name, " ", "")), 0, 20),
    substr(lower(replace(each.value.last_name,  " ", "")), 0, 20),
    local.domain_name[0]
  )

  # Ensure complexity: Uppercase + lowercase + digits + special, length >= 8
  password = format(
    "%s%s%s",
    upper(substr(replace(each.value.first_name, " ", ""), 0, 1)),
    lower(replace(each.value.last_name,  " ", "")),
    "!2025"
  )

  display_name = format("%s %s", each.value.first_name, each.value.last_name)

  force_password_change = true
  department            = each.value.department
  job_title             = each.value.job_title

}

output "domain_names" {
  value = local.domain_name
}

output "username" {
  value = [for user in local.users : lower(replace("${user.first_name}.${user.last_name}@${local.domain_name[0]}", " ", ""))]
    description = "List of usernames created from CSV file"
}