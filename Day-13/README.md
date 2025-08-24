# Day 13: Data Sources

## 📌 Overview
Terraform data sources let you read existing Azure resources and use their attributes in your config. They are read-only and don’t create or change resources.

We’ll cover:
- What data sources are and why use them
- The Azure examples used in this project
- Tips and best practices

---

## 1️⃣ What is a data source?
- A read-only view of an existing resource
- Declared with a `data` block
- Helps avoid hardcoding IDs, names, locations

Example – read an existing Resource Group and use its attributes:
```hcl
data "azurerm_resource_group" "rg" {
  name = "my-existing-rg"
}

resource "azurerm_storage_account" "sa" {
  name                     = "examplestg123456"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

---

## 2️⃣ Azure examples in this folder
This project reads a shared network and places a VM in a new RG:

```hcl
data "azurerm_resource_group" "rg-shared" {
  name = "shared-network-rg"
}

data "azurerm_virtual_network" "vnet-shared" {
  name                = "shared-network-vnet"
  resource_group_name = data.azurerm_resource_group.rg-shared.name
}

data "azurerm_subnet" "subnet-shared" {
  name                 = "shared-primary-sn"
  resource_group_name  = data.azurerm_resource_group.rg-shared.name
  virtual_network_name = data.azurerm_virtual_network.vnet-shared.name
}

resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-rg"
  location = data.azurerm_resource_group.rg-shared.location
}
```

Provision the shared network first (idempotent):
```bash
bash Projects/day_13_Data_Sources/scripts/setup-shared-network.sh
```

---

## 3️⃣ Tips and best practices
- Prefer data sources over hardcoded IDs
- Keep names consistent across environments
- Validate existence early with a small `terraform plan`

---

## 📚 Resources
- Data Sources: https://developer.hashicorp.com/terraform/language/data-sources
- AzureRM Provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs