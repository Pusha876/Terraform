#!/usr/bin/env bash
set -euo pipefail

# Idempotently create Azure resources for Terraform azurerm backend.
# Defaults match backend.tf in this project.
#
# Usage:
#   ./scripts/backend.sh \
#     [-g day14-rg] [-s day14tfstate] [-c tfstate] [-k mini/day14-vmss.terraform.tfstate] [-l eastus]
#
# Notes:
# - Requires Azure CLI (az) logged in with sufficient permissions.
# - Storage account names must be globally unique, lowercase, 3–24 chars.

RG_NAME="${RG_NAME:-day14-rg}"
SA_NAME="${SA_NAME:-day14tfstate}"
CONTAINER_NAME="${CONTAINER_NAME:-tfstate}"
STATE_KEY="${STATE_KEY:-mini/day14-vmss.terraform.tfstate}"
LOCATION="${LOCATION:-eastus}"

while getopts ":g:s:c:k:l:h" opt; do
  case $opt in
    g) RG_NAME="$OPTARG" ;;
    s) SA_NAME="$OPTARG" ;;
    c) CONTAINER_NAME="$OPTARG" ;;
    k) STATE_KEY="$OPTARG" ;;
    l) LOCATION="$OPTARG" ;;
    h)
      echo "Usage: $0 [-g rg-name] [-s sa-name] [-c container] [-k state-key] [-l location]";
      exit 0
      ;;
    \?) echo "Invalid option -$OPTARG" >&2; exit 1 ;;
  esac
done

command -v az >/dev/null 2>&1 || { echo "Azure CLI 'az' is required" >&2; exit 1; }

echo "Ensuring Resource Group: $RG_NAME ($LOCATION)"
az group create -n "$RG_NAME" -l "$LOCATION" -o none

echo "Ensuring Storage Account: $SA_NAME in $RG_NAME ($LOCATION)"
az storage account show -n "$SA_NAME" -g "$RG_NAME" -o none 2>/dev/null || \
  az storage account create -n "$SA_NAME" -g "$RG_NAME" -l "$LOCATION" \
    --sku Standard_LRS --kind StorageV2 \
    --min-tls-version TLS1_2 \
    --allow-blob-public-access false \
    -o none

echo "Ensuring Container: $CONTAINER_NAME in $SA_NAME"
# Use AAD auth to avoid access keys
az storage container show --account-name "$SA_NAME" --name "$CONTAINER_NAME" --auth-mode login -o none 2>/dev/null || \
  az storage container create --account-name "$SA_NAME" --name "$CONTAINER_NAME" --auth-mode login -o none

echo
echo "Backend configuration (copy into backend.tf if needed):"
cat <<EOF
terraform {
  backend "azurerm" {
    resource_group_name  = "$RG_NAME"
    storage_account_name = "$SA_NAME"
    container_name       = "$CONTAINER_NAME"
    key                  = "$STATE_KEY"
  }
}
EOF

echo
echo "Done. You can now run: tf init -reconfigure"
