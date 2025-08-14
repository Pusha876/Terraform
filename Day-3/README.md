# Day 3: Resource Group and Storage Account

## 📌 Overview
Today we explore **Azure resource management with Terraform**, focusing on:
- Authenticating Terraform to access Azure
- Creating **Resource Groups**
- Managing **Storage Accounts**
- Understanding resource dependencies

---

## 1️⃣ Authentication and Authorization to Azure Resources

To allow Terraform to manage Azure resources, authenticate using one of the supported methods.

### Methods
1. **Azure CLI (local/dev):**
   ```bash
   az login
   ```
   Terraform will automatically use your Azure CLI context.

2. **Service Principal (recommended for CI/CD):**
   Create a service principal and assign a role at subscription scope:
   ```bash
   az ad sp create-for-rbac \
     --name terraform-sp \
     --role "Contributor" \
     --scopes "/subscriptions/<SUBSCRIPTION_ID>"
   ```
   Export environment variables so Terraform can authenticate:
   ```bash
   export ARM_CLIENT_ID="<APP_ID>"
   export ARM_CLIENT_SECRET="<PASSWORD>"
   export ARM_TENANT_ID="<TENANT_ID>"
   export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
   ```
   Note (Git Bash on Windows): wrap the scope in quotes to avoid path conversion.

3. **Managed Identity (in Azure):**
   Use when running Terraform from an Azure VM/Agent with a system- or user-assigned identity. Grant RBAC (e.g., Contributor) to the target scope.

---

## 2️⃣ Creating Resource Groups

A Resource Group is a logical container for Azure resources.

### Example (HCL)
```hcl
resource "azurerm_resource_group" "example" {
  name     = "rg-demo"
  location = "East US"
  tags = {
    environment = "demo"
  }
}
```

### Best Practices
- Use consistent naming conventions
- Group related resources together
- Apply tags for cost and ownership

---

## 3️⃣ Storage Account Management

An Azure Storage Account provides Blob, File, Queue, and Table services.

### Example (HCL)
```hcl
resource "azurerm_storage_account" "example" {
  name                     = "stgdemoproject123"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    environment = "demo"
  }
}
```

### Key Options
- `account_tier`: `Standard` or `Premium`
- `account_replication_type`: `LRS`, `GRS`, `ZRS`, `RAGRS`
- Network rules for secure access (e.g., private endpoints, firewall)

---

## 4️⃣ Understanding Dependencies

Terraform infers dependencies when one resource references another (implicit). You can also declare explicit dependencies.

### Explicit Dependency Example (HCL)
```hcl
resource "azurerm_storage_container" "example" {
  name                  = "demo-container"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"

  depends_on = [
    azurerm_storage_account.example
  ]
}
```

### Why it matters
- Ensures correct creation order
- Prevents failures due to missing prerequisites
- Improves clarity in complex configurations

---

## 📚 Resources
- Terraform AzureRM Provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
- Azure Resource Manager Overview: https://learn.microsoft.com/azure/azure-resource-manager/management/overview
- Terraform depends_on: https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on


Terraform Depends On Documentation
