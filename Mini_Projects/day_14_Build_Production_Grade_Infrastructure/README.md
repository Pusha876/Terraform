# Day 14: Production-grade Infrastructure (Mini Project)

This mini project provisions an Azure VMSS behind a Load Balancer with cloud-init and SSH.

## Provider & Backend
- Provider: azurerm ~> 3.x with features {}
- Remote state backend: tfstate-day04 / tfstate1684828945 / container tfstate
  - Key: mini/day14-vmss.terraform.tfstate

## Default Tags
Applied automatically to all resources:
- project: day14-vmss
- environment: var.environment (from TF_ENVIRONMENT or defaults to dev)
- owner: var.owner (from TF_OWNER or defaults to unknown)

## SSH
- Default public key path: ./ssh/id_ed25519.pub
- Generate one locally:
```bash
ssh-keygen -t ed25519 -C "vmss" -f ./ssh/id_ed25519 -N ""
```
Override path with: `-var="ssh_public_key_path=~/.ssh/id_rsa.pub"`.

## Environment variables (optional)
Set to drive tags without editing vars:
```bash
export TF_ENVIRONMENT=dev
export TF_OWNER=jamie
```

## Init & Plan
```bash
tf init -reconfigure
tf plan -compact-warnings
```
