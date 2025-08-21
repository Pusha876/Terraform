# Day 9: The Lifecycle Meta-Arguments
# Day 9: Lifecycle Rules in Terraform

## 📌 Overview
Terraform’s `lifecycle` and in-resource conditions control how resources are created, updated, and destroyed. Use them to prevent accidental deletions, force replacement order, and ignore noisy drift.

We’ll cover:
- `prevent_destroy` to block deletes
- `create_before_destroy` to reduce downtime during replaces
- `ignore_changes` to avoid unwanted updates
- `precondition` and `postcondition` for safety checks

---

## 1️⃣ prevent_destroy

Block deletion of a resource (helpful for critical assets like prod RGs or Key Vaults).
```hcl
resource "azurerm_resource_group" "critical" {
  name     = "rg-prod"
  location = "Sweden Central"

  lifecycle {
    prevent_destroy = true
  }
}
```
Trying to destroy this resource will fail unless you temporarily remove the flag.

---

## 2️⃣ create_before_destroy

When a change requires replacement, create the new resource first, then destroy the old one.
```hcl
resource "azurerm_public_ip" "pip" {
  name                = "demo-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"

  lifecycle {
    create_before_destroy = true
  }
}
```
This reduces downtime for resources that support parallel existence.

---

## 3️⃣ ignore_changes

Ignore fields that are changed externally (e.g., by a platform policy or operator) to prevent perpetual diffs.
```hcl
resource "azurerm_storage_account" "sa" {
  name                     = "exampleuniquename123"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags = {
    environment = "dev"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
```

---

## 4️⃣ Preconditions and Postconditions

Add safety checks evaluated during plan/apply.
```hcl
resource "azurerm_resource_group" "rg" {
  name     = "demo-rg"
  location = var.location

  lifecycle {
    precondition {
      condition     = contains(["swedencentral", "westeurope", "northeurope"], lower(self.location))
      error_message = "location must be one of: Sweden Central, West Europe, North Europe."
    }
  }
}
```
Tip: Use `self.<attr>` to validate the planned value when your attribute is computed from expressions.

---

## 📌 Summary
- `prevent_destroy`: prevent accidental deletes.
- `create_before_destroy`: minimize downtime during replacements.
- `ignore_changes`: avoid noisy drift from external changes.
- Preconditions/Postconditions: assert invariants at plan/apply.

---

## 📚 Resources
- Lifecycle Meta-arguments: https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle
- Resource Behavior: https://developer.hashicorp.com/terraform/language/resources/behavior
- Conditions: https://developer.hashicorp.com/terraform/language/resources/behavior#precondition-and-postcondition
