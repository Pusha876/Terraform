resource "azuread_group" "engineering" {
  security_enabled = true
    display_name     = "Engineering"
}

resource "azuread_group_member" "education" {
  for_each = { for k, u in azuread_user.users : k => u if u.department == "Engineering" }
    group_object_id  = azuread_group.engineering.object_id
    member_object_id = each.value.object_id
}

resource "azuread_group" "managers" {
  security_enabled = true
    display_name     = "Managers"
}

resource "azuread_group_member" "managers" {
  for_each = { for k, u in azuread_user.users : k => u if u.job_title == "Manager" }
    group_object_id  = azuread_group.managers.object_id
    member_object_id = each.value.object_id
}

resource "azuread_group_member" "engineers" {
  for_each = { for k, u in azuread_user.users : k => u if u.job_title == "Engineer" }
    group_object_id  = azuread_group.engineering.object_id
    member_object_id = each.value.object_id
}
output "group_ids" {
  value = {
    engineering_group_id = azuread_group.engineering.id
    managers_group_id    = azuread_group.managers.id
  }
}