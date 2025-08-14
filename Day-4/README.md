# Day 4: State File Management – Remote Backend

## 📌 Overview
Today we dive into **Terraform state management**, learning:
- How Terraform updates infrastructure
- What the **state file** is and why it matters
- Best practices for handling the state file
- How to set up a **remote backend** (Azure Blob Storage)
- Safe and collaborative state strategies

---

## 1️⃣ How Terraform Updates Infrastructure

Terraform follows a **desired state** model:
1. **Read current state** – Load existing state from the state file (and refresh from the provider when needed)
2. **Compare** – Diff the current state vs configuration
3. **Plan** – Propose the required changes
4. **Apply** – Execute the plan to reach the desired state

This ensures Terraform only changes what’s needed.

---

## 2️⃣ Terraform State File

- The **state file** (`terraform.tfstate`) maps your configuration to real resources.
- Stores resource IDs, metadata, and dependencies.
- Required for incremental, accurate plans and applies.

**Example snippet:**
```json
{
  "resources": [
    {
      "type": "azurerm_resource_group",
      "name": "example",
      "instances": [
        {
          "attributes": {
            "name": "rg-demo",
            "location": "East US"
          }
        }
      ]
    }
  ]
}
```

---

## 3️⃣ State File Best Practices

✅ DO
- Use a remote backend for collaboration
- Enable state locking to prevent concurrent changes
- Secure state (it may contain sensitive data)
- Version and back up remote storage

❌ AVOID
- Committing `.tfstate` to version control
- Editing state manually (can corrupt it)
- Running concurrent applies without locking

---

## 4️⃣ Remote Backend Setup (Azure Blob Storage)

Store state in an Azure Storage container to centralize and lock state.

Run the helper script to create the backend resources and print exact values:
```bash
./Projects/day_4_State_File_Management/backend.sh
```
It outputs the resource group, storage account, and container names. Use those values in your backend block below.

**Backend configuration (HCL):**
```hcl
terraform {
  backend "azurerm" {
  resource_group_name   = "tfstate-day04"        # from backend.sh
  storage_account_name  = "<paste-from-script>"  # backend.sh prints a unique name like tfstate12345
  container_name        = "tfstate"              # from backend.sh
  key                   = "terraform.tfstate"
  }
}
```

> Tip: After updating backend.tf, run `terraform init -reconfigure` to set or migrate the backend.

**Benefits**
- Centralized, shared state for teams
- State locking via Azure Blob leases
- Better durability and recovery

---

## 5️⃣ State Management Commands

View state overview:
```bash
terraform show
terraform state list
```

Inspect a resource:
```bash
terraform state show <resource_address>
```

Remove from state (does not delete resource):
```bash
terraform state rm <resource_address>
```

Move/rename in state:
```bash
terraform state mv <old_address> <new_address>
```

Migrate to a new backend:
```bash
terraform init -migrate-state
```

---

## 📚 Resources
- Terraform State: https://developer.hashicorp.com/terraform/language/state
- Backends (Remote State): https://developer.hashicorp.com/terraform/language/settings/backends/configuration
- AzureRM Backend: https://developer.hashicorp.com/terraform/language/settings/backends/azurerm