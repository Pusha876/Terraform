# Day 1: Introduction to Terraform

## 📌 Overview
Today’s focus is on understanding **Infrastructure as Code (IaC)**, why it’s important, and how Terraform fits into modern infrastructure management.  
We’ll explore Terraform’s benefits, the problems it solves compared to traditional methods, and its core workflow. Finally, we’ll cover how to install Terraform.

---

## 1️⃣ Understanding Infrastructure as Code (IaC)

**Infrastructure as Code** is the practice of managing and provisioning infrastructure through machine-readable configuration files, rather than manual hardware or interactive configuration tools.

### Key Points:
- Uses **code** to define infrastructure resources.
- Enables version control (Git, etc.).
- Facilitates automation and repeatability.
- Reduces human error.

---

## 2️⃣ Why We Need IaC
Without IaC, infrastructure changes are often manual, slow, and error-prone.

**Benefits of IaC:**
- **Consistency:** Same configuration across environments (dev, staging, prod).
- **Speed:** Automates provisioning, reducing setup time.
- **Collaboration:** Teams can review and track changes through version control.
- **Scalability:** Easily replicate or scale environments.

---

## 3️⃣ What is Terraform and Its Benefits

**Terraform** is an open-source IaC tool created by [HashiCorp](https://www.terraform.io/).  
It allows you to define cloud and on-prem infrastructure in a **declarative configuration language** (HCL – HashiCorp Configuration Language).

### Terraform Benefits:
- **Cloud Agnostic:** Works with AWS, Azure, GCP, and many others.
- **Declarative Language:** Define the desired state; Terraform figures out how to get there.
- **Execution Plan:** Previews changes before applying them.
- **State Management:** Keeps track of infrastructure state for incremental changes.
- **Modular:** Encourages reusable, organized configurations.

---

## 4️⃣ Challenges with the Traditional Approach

**Traditional infrastructure management issues:**
- Manual CLI or UI configuration prone to human error.
- Documentation often becomes outdated.
- No clear history of changes.
- Difficult to scale infrastructure quickly.
- Environment drift — differences between staging and production.

---

## 5️⃣ Terraform Workflow

Typical Terraform workflow:

1. **Write** – Create `.tf` configuration files describing infrastructure.
2. **Init** – Run `terraform init` to download provider plugins.
3. **Plan** – Run `terraform plan` to see proposed changes.
4. **Apply** – Run `terraform apply` to provision infrastructure.
5. **Destroy** – Run `terraform destroy` to remove infrastructure when no longer needed.

---

## 6️⃣ Installing Terraform

### Steps:
1. Download Terraform from the official [Terraform Downloads](https://developer.hashicorp.com/terraform/downloads) page.
2. Extract the archive and move the executable to a directory included in your system’s `PATH`.
3. Verify installation:
   ```bash
   terraform -version
