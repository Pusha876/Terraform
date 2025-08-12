# Terraform Azure Projects

## 📌 Overview
This repository contains Terraform projects demonstrating Infrastructure as Code (IaC) implementations for Azure resources.  
Each project focuses on specific Azure services and Terraform concepts, providing practical examples for learning and development.

---

## 🗂️ Projects

### Day 3: Azure Storage Account
**Location:** `day_3_Azure_Storage_Account/`

**Description:**  
A fundamental Terraform project that provisions an Azure Storage Account with its required resource group. This project demonstrates basic Azure resource creation, implicit dependencies, and resource tagging.

**Resources Created:**
- **Resource Group:** `example-resources` (West Europe)
- **Storage Account:** `az400storageacct` with Standard LRS replication

**Key Features:**
- Uses AzureRM provider v3.0+
- Demonstrates implicit dependency between storage account and resource group
- Includes resource tagging for environment classification
- Standard LRS (Locally Redundant Storage) configuration

**Prerequisites:**
- Azure CLI installed and authenticated
- Terraform installed (v0.12+)
- Azure service principal with Contributor role
- Environment variables configured for authentication

**Usage:**
```bash
cd day_3_Azure_Storage_Account
source var.sh  # Load environment variables
terraform init
terraform plan
terraform apply
terraform destroy  # Clean up resources when done
```

---

## 🔧 Authentication Setup

This project uses Azure service principal authentication. Ensure the following environment variables are set:

```bash
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_TENANT_ID="your-tenant-id"
export ARM_SUBSCRIPTION_ID="your-subscription-id"
```

**Note:** Credential files (`var.sh`, `*.env`) are ignored by Git for security.

---

## 📚 Learning Objectives

- Understanding Terraform provider configuration
- Working with Azure Resource Manager (ARM) resources
- Implementing resource dependencies
- Using resource tagging strategies
- Managing Terraform state
- Following security best practices for credentials

---

## 🛡️ Security Notes

- All credential files are excluded from version control via `.gitignore`
- Service principal follows principle of least privilege
- Environment variables are used for sensitive authentication data
- State files contain sensitive information and should be secured appropriately

---

## 🤝 Contributing

When adding new projects:
1. Create a descriptive folder name (e.g., `day_X_Service_Name`)
2. Include comprehensive documentation
3. Follow consistent naming conventions
4. Ensure credentials are properly excluded from Git
5. Update this README with project details
