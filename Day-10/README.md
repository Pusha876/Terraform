# Day 10: Dynamic Blocks and Expressions

## 📌 Overview
Terraform’s dynamic blocks and expressions make configurations flexible and DRY.

We’ll cover:
- Dynamic blocks
- Conditional expressions
- Splat expressions
- Practical patterns

---

## 1️⃣ Dynamic blocks

Generate nested blocks programmatically inside a resource.

Example – dynamic security rules on an NSG:
```hcl
variable "rules" {
  type = list(object({
    name     = string
    priority = number
    port     = number
    desc     = optional(string, "")
  }))
  default = [
    { name = "rule1", priority = 100, port = 22,  desc = "Allow SSH" },
    { name = "rule2", priority = 200, port = 80,  desc = "Allow HTTP" }
  ]
}

resource "azurerm_network_security_group" "example" {
  name                = "nsg-demo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = var.rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.port
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = security_rule.value.desc
    }
  }
}
```

---

## 2️⃣ Conditional expressions

If-else logic in expressions: `condition ? true_val : false_val`
```hcl
variable "environment" { default = "dev" }

resource "azurerm_virtual_machine" "example" {
  name     = "vm1"
  location = "East US"
  size     = var.environment == "prod" ? "Standard_B2s" : "Standard_B1s"
}
```

---

## 3️⃣ Splat expressions

Extract attributes across multiple instances.
```hcl
resource "azurerm_public_ip" "example" {
  count               = 3
  name                = "public-ip-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

output "public_ips" {
  value = azurerm_public_ip.example[*].ip_address
}
```

---

## 4️⃣ Practical patterns

Conditional resource creation with count:
```hcl
variable "create_storage" { type = bool, default = true }

resource "azurerm_storage_account" "example" {
  count                    = var.create_storage ? 1 : 0
  name                     = "stgexample123"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

---

## � Summary
- Dynamic blocks: generate nested blocks from data.
- Conditional expressions: inline decisions.
- Splat expressions: collect attributes from many instances.

---

## �📚 Resources
- Dynamic Blocks: https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks
- Conditional Expressions: https://developer.hashicorp.com/terraform/language/expressions/conditionals
- Splat Expressions: https://developer.hashicorp.com/terraform/language/expressions/splat