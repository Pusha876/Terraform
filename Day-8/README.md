Day 8: Meta-arguments in Terraform

Terraform meta-arguments let you control how resources are created, managed, and reused. They aren’t tied to a single resource type — instead, they work across many resources and modules.

🔹 1. count

Used to create multiple instances of the same resource.

Value must be a whole number.

Useful when you know exactly how many resources you want.
# Day 8: Meta-arguments in Terraform

## 📌 Overview
Terraform meta-arguments control how resources are created, managed, and reused. They’re not tied to one resource type they work across many resources and modules.

We’ll cover:
- `count` for fixed multiples
- `for_each` for map/set-driven instances
- `for` expressions to transform/filter data used by resources
- Bonus: `depends_on` and `lifecycle`

---

## 1️⃣ count

Create multiple instances of the same resource. The value must be a whole number.
```hcl
resource "azurerm_resource_group" "example" {
  count    = 3
  name     = "rg-example-${count.index}"
  location = "East US"
}

# Reference a specific instance
output "first_rg_name" {
  value = azurerm_resource_group.example[0].name
}
```

---

## 2️⃣ for_each

Create instances from a map or set. Use `each.key` and `each.value` inside the resource.

Example with a map:
```hcl
variable "rgs" {
  type = map(string)
  default = {
    dev  = "East US"
    prod = "West US"
  }
}

resource "azurerm_resource_group" "example" {
  for_each = var.rgs
  name     = "rg-${each.key}"
  location = each.value
}
```

Example with a set of strings:
```hcl
variable "regions" {
  type    = set(string)
  default = ["East US", "West US"]
}

resource "azurerm_resource_group" "regional" {
  for_each = toset(var.regions)
  name     = "rg-${replace(lower(each.value), " ", "-")}"
  location = each.value
}
```

---

## 3️⃣ for expressions (loops)

Transform or filter lists/maps to shape data for resources.

Transform list to map:
```hcl
variable "locations" {
  type    = list(string)
  default = ["East US", "West US", "North Europe"]
}

output "location_map" {
  value = { for idx, loc in var.locations : idx => loc }
}
```

Filter a list:
```hcl
variable "names" {
  type    = list(string)
  default = ["app1", "app2", "test1"]
}

output "filtered" {
  value = [for n in var.names : n if n != "test1"]
}
```

---

## 4️⃣ Practical patterns

Combine `for_each` with a filtered map (only create prod):
```hcl
variable "environments" {
  type = map(string)
  default = {
    dev  = "East US"
    prod = "West US"
    qa   = "Central US"
  }
}

resource "azurerm_resource_group" "example" {
  for_each = { for k, v in var.environments : k => v if k == "prod" }
  name     = "rg-${each.key}"
  location = each.value
}
```

Bonus meta-arguments:
```hcl
# Explicit dependency (when Terraform can’t infer it)
resource "null_resource" "post" {
  depends_on = [azurerm_resource_group.example]
}

# Control replace/create/delete behavior
resource "azurerm_resource_group" "managed" {
  name     = "rg-managed"
  location = "East US"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags]
  }
}
```

---

## 📌 Summary
- `count`: fixed number of instances.
- `for_each`: dynamic instances from maps/sets.
- `for` expressions: transform/filter input data.
- `depends_on`/`lifecycle`: fine-tune ordering and updates.

---

## 📚 Resources
- Meta-arguments: https://developer.hashicorp.com/terraform/language/meta-arguments
- count and for_each: https://developer.hashicorp.com/terraform/language/meta-arguments/resource
- for expressions: https://developer.hashicorp.com/terraform/language/expressions/for
- lifecycle: https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle
- depends_on: https://developer.hashicorp.com/terraform/language/resources/behavior#explicit-resource-dependencies