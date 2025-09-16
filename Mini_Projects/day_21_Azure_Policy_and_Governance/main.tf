data "azurerm_subscription" "current" {}

resource "azurerm_policy_definition" "tag" {
  name         = "allowed-tag"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed Tags policy"
  description  = "This policy ensures that only specified tags are allowed on resources."

  policy_rule = <<POLICY_RULE
{
  "if": {
    "anyOf": [
      {
        "field": "tags['Environment']",
        "exists": "false"
      },
      {
        "field": "tags['Department']",
        "exists": "false"
      }
    ]
  },
  "then": {
    "effect": "deny"
  }
}
POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "example" {
  name                 = "tag-assignment"
  policy_definition_id = azurerm_policy_definition.tag.id
  subscription_id      = data.azurerm_subscription.current.id
}

resource "azurerm_subscription_policy_assignment" "example1" {
  name                 = "size-assignment"
  policy_definition_id = azurerm_policy_definition.vm_size.id
  subscription_id      = data.azurerm_subscription.current.id
}


resource "azurerm_policy_definition" "location" {
  name         = "location"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed location policy"

  policy_rule = jsonencode({
    if = {
        field = "location",
        notIn = ["${var.location[0]}","${var.location[1]}"]
      },       
    then = {
      effect = "deny"
  }
  
})



}

resource "azurerm_policy_definition" "vm_size" {
  name         = "vm-size"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed VM size policy"

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field = "type"
          equals = "Microsoft.Compute/virtualMachines"
        },
        {
          not = {
            field = "Microsoft.Compute/virtualMachines/sku.name"
            in = ["Standard_DS1_v2", "Standard_B2s"]
          }
        }
      ]
    }
    then = {
      effect = "deny"
    }
  })
}

