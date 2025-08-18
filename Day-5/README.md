# Day 5: Variables

## 📌 Overview
Today we focus on **variables in Terraform** — making configurations reusable, organized, and dynamic. We’ll cover:
- Input variables
- Output variables
- Local values
- Variable precedence
- Variable files (`.tfvars`)

---

## 1️⃣ Input Variables

Input variables let you pass dynamic values into your Terraform configuration.

```hcl
variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

resource "azurerm_resource_group" "example" {
  name     = "rg-demo"
  location = var.location
}
```

Run with an override value:
```bash
terraform apply -var="location=West US"
```

You can add validation and sensitive flags:
```hcl
variable "env" {
  type        = string
  description = "Environment name"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.env)
    error_message = "env must be one of dev, staging, prod."
  }
}
```

---

## 2️⃣ Output Variables

Outputs return information after apply. Useful for displaying attributes or passing values to modules/parent stacks.

```hcl
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.example.name
}
```

Show outputs:
```bash
terraform output
terraform output resource_group_name
```

---

## 3️⃣ Locals

Local values hold computed or reusable expressions within the configuration.

```hcl
locals {
  resource_prefix = "demo"
  location        = "East US"
}

resource "azurerm_resource_group" "example" {
  name     = "${local.resource_prefix}-rg"
  location = local.location
}
```

---

## 4️⃣ Variable Precedence (highest to lowest)

1. Command line flags (`-var` and `-var-file`)
2. Environment variables (`TF_VAR_<name>`)
3. `terraform.tfvars` file
4. `*.auto.tfvars` files
5. Default value in `variable` block

Example environment variable:
```bash
export TF_VAR_location="West US"
```

---

## 5️⃣ Variable Files (`.tfvars`)

Store variables in separate files for easier management.

`terraform.tfvars`:
```hcl
location        = "West US"
resource_prefix = "prod"
```

Apply with a specific file:
```bash
terraform apply -var-file="terraform.tfvars"
```

Auto-load behavior:
- `terraform.tfvars` (auto-loaded)
- Any `*.auto.tfvars` file (auto-loaded)

---

## 📚 Resources
- Input Variables: https://developer.hashicorp.com/terraform/language/values/variables
- Output Values: https://developer.hashicorp.com/terraform/language/values/outputs
- Local Values: https://developer.hashicorp.com/terraform/language/values/locals
- Variable Files: https://developer.hashicorp.com/terraform/language/files/terraform