Day 11 & 12: Functions in Terraform
# Day 11 & 12: Functions

## 📌 Overview
Terraform functions transform and compose values so your configs are DRY, flexible, and safer than hardcoding. All functions are built-in—no imports needed.

We’ll cover:
- String functions
- Numeric functions
- Collection functions
- Encoding/decoding (JSON/Base64)
- Date & time
- Practical Azure examples

---

## 1️⃣ String functions
Text manipulation helpers.

```hcl
upper("hello")           # "HELLO"
lower("WORLD")           # "world"
replace("abc123","123","xyz") # "abcxyz"
substr("terraform", 0, 4)        # "terr"
trim("  azurerm  ")              # "azurerm"
```

---

## 2️⃣ Numeric functions
Numbers, rounding, and aggregation.

```hcl
min(5, 10, 3)   # 3
max(5, 10, 3)   # 10
ceil(3.14)      # 4
floor(3.14)     # 3
abs(-7)         # 7
```

---

## 3️⃣ Collection functions
Work with lists, maps, sets, and tuples.

```hcl
length(["a","b","c"])                 # 3
concat(["a","b"],["c","d"])         # ["a","b","c","d"]
join("-", ["us","east","1"])        # "us-east-1"
lookup({ env = "prod", region = "eastus" }, "region") # "eastus"
keys({a=1,b=2})                             # ["a","b"]
```

---

## 4️⃣ Encoding & decoding
Handle Base64 and JSON.

```hcl
base64encode("hello")                        # "aGVsbG8="
base64decode("aGVsbG8=")                    # "hello"
jsonencode({ name = "Jamie", age = 30 })    # '{"name":"Jamie","age":30}'
jsondecode('{"name":"Jamie","age":30}').name  # "Jamie"
```

---

## 5️⃣ Date & time
Great for automation and naming.

```hcl
timestamp()                          # e.g. "2025-08-18T20:15:00Z"
formatdate("YYYY-MM-DD", timestamp())  # e.g. "2025-08-18"
```

---

## 🌍 Practical examples

### Example 1: Dynamic storage name
```hcl
resource "azurerm_storage_account" "example" {
  name                     = "storage${lower(var.env)}${substr(uuid(), 0, 6)}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```
Uses `lower()`, `substr()`, and `uuid()` for uniqueness.

### Example 2: Joining regions
```hcl
variable "regions" {
  type    = list(string)
  default = ["eastus", "westus", "centralus"]
}

output "region_string" {
  value = join(",", var.regions)  # "eastus,westus,centralus"
}
```

### Example 3: Lookup from a map
```hcl
variable "config" {
  type = map(string)
  default = {
    dev  = "Standard_LRS"
    prod = "Premium_LRS"
  }
}

output "storage_sku" {
  value = lookup(var.config, "prod", "Standard_LRS")  # "Premium_LRS"
}
```

### Example 4: JSON encode/decode
```hcl
locals {
  user = {
    name = "Jamie"
    role = "DevOps"
  }
}

output "json_example" {
  value = jsonencode(local.user)
}
```

---

## ✅ Tasks for practice
- Create a dynamic storage name with `lower()`, `substr()`, and `uuid()`.
- Output a list variable as a CSV string using `join()`.
- Use `lookup()` to choose a VM size per environment (dev/test/prod).
- Encode a map with `jsonencode()` and parse it back with `jsondecode()`.
- Print today’s date with `formatdate()` and `timestamp()`.

---

## 📚 Resources
- Terraform Functions (all): https://developer.hashicorp.com/terraform/language/functions
- String: https://developer.hashicorp.com/terraform/language/functions#string-functions
- Numeric: https://developer.hashicorp.com/terraform/language/functions#numeric-functions
- Collection: https://developer.hashicorp.com/terraform/language/functions#collection-functions
- Encoding: https://developer.hashicorp.com/terraform/language/functions#encoding-functions