# Day 7: Type Constraints in Terraform

## 📌 Overview
Today we explore **type constraints** in Terraform. They validate inputs early and make configurations safer and clearer.

We’ll cover:
- Primitive types: `string`, `number`, `bool`
- Collection types: `list`, `set`, `map`
- Structural types: `tuple`, `object`
- Tips for validation and practical Azure tagging patterns

---

## 1️⃣ Primitive Types

### String
```hcl
variable "vm_name" {
  type    = string
  default = "demo-vm"
}
```

### Number
Represents integers or floating-point numbers.
```hcl
variable "instance_count" {
  type    = number
  default = 2
}
```

### Bool
Represents true/false values.
```hcl
variable "enable_monitoring" {
  type    = bool
  default = true
}
```

---

## 2️⃣ Collection Types

### List
An ordered sequence of values of the same type.
```hcl
variable "subnets" {
  type    = list(string)
  default = ["subnet-1", "subnet-2", "subnet-3"]
}
```

### Set
An unordered collection of unique values (no duplicates).
```hcl
variable "regions" {
  type    = set(string)
  default = ["eastus", "westus"]
}
```

### Map
A key-value collection where all values share the same type.
```hcl
variable "tags" {
  type = map(string)
  default = {
    environment = "dev"
    owner       = "team1"
  }
}
```

---

## 3️⃣ Structural Types

### Tuple
An ordered sequence of values, potentially of different types.
```hcl
variable "app_config" {
  type    = tuple([string, number, bool])
  default = ["web-app", 3, true]
}
```

### Object
A collection of named attributes, each with its own type.
```hcl
variable "vm_settings" {
  type = object({
    name     = string
    size     = string
    enabled  = bool
    priority = number
  })

  default = {
    name     = "vm1"
    size     = "Standard_B1s"
    enabled  = true
    priority = 1
  }
}
```

---

## 4️⃣ Tips, Validation, and Practical Use

- Optional object attributes can be modeled with `optional(type, default)` in newer Terraform versions.
- Use `validation` blocks to constrain values:
```hcl
variable "location" {
  type = string
  validation {
    condition     = contains(["swedencentral", "westeurope", "northeurope"], lower(var.location))
    error_message = "location must be one of: Sweden Central, West Europe, North Europe."
  }
}
```
- Common Azure tagging pattern (merge fixed and user-provided tags):
```hcl
variable "resource_tag" {
  type = map(string)
  default = {
    owner = "team1"
  }
}

variable "environment" { type = string }

locals {
  base_tags = {
    costcenter = "cc-1234"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "demo-rg"
  location = var.location
  tags     = merge(local.base_tags, var.resource_tag, { environment = var.environment })
}
```

---

## 📚 Resources
- Type Constraints: https://developer.hashicorp.com/terraform/language/expressions/type-constraints
- Types: https://developer.hashicorp.com/terraform/language/expressions/types
- Variable Validation: https://developer.hashicorp.com/terraform/language/values/variables#custom-validation-rules