# Day 6: File Structure

## 📌 Overview
Today we cover how to organize **Terraform projects** for readability, scalability, and team collaboration:
- Terraform file organization
- File loading sequence
- Structure best practices and modules
- Version pinning and secrets hygiene

---

## 1️⃣ Terraform File Organization

Terraform reads all files ending in `.tf` or `.tf.json` in the working directory.

### Common files
- `main.tf` → Core resources/module calls
- `variables.tf` → Input variable definitions
- `outputs.tf` → Output values
- `provider.tf` → Provider config and features {}
- `versions.tf` → Required Terraform and provider versions
- `terraform.tfvars` / `*.auto.tfvars` → Variable values (do not commit secrets)

**Example layout:**
```
project-root/
├─ main.tf
├─ variables.tf
├─ outputs.tf
├─ provider.tf
├─ versions.tf
└─ terraform.tfvars
```

---

## 2️⃣ Sequence of File Loading

Terraform loads configuration in this way:
1. Combines all `.tf` files into a single configuration internally (filename order doesn’t matter)
2. Loads variable definitions from:
   - `terraform.tfvars`
   - any `*.auto.tfvars`
   - files passed via `-var-file`
3. Applies variable precedence (CLI > env vars > tfvars > defaults)

⚡ Terraform treats multiple `.tf` files in a folder as one configuration.

---

## 3️⃣ Best Practices for Structure

✅ Organize by purpose
- Resources in `main.tf`
- Variables in `variables.tf`
- Outputs in `outputs.tf`
- Provider settings in `provider.tf`

✅ Use modules for reuse
```
modules/
└─ vnet/
   ├─ main.tf
   ├─ variables.tf
   └─ outputs.tf
```

Use a module from root:
```hcl
module "vnet" {
  source = "./modules/vnet"
  # ...inputs
}
```

✅ Version pinning
Define required versions in `versions.tf`:
```hcl
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
```

✅ Keep secrets out of code
- Use environment variables or secret managers
- Avoid hardcoding credentials in `.tf` files
- Add `.tfvars` with secrets to `.gitignore`

✅ Consistent naming & tagging
- Improves readability and cost/ownership tracking

---

## 📚 Resources
- Configuration Language: https://developer.hashicorp.com/terraform/language
- Recommended Practices: https://developer.hashicorp.com/terraform/language/modules/develop