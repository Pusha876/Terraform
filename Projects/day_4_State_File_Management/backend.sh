#!/bin/bash
set -euo pipefail

# Config
LOCATION="eastus"
RESOURCE_GROUP_NAME="tfstate-day04"
# Storage account name must be globally unique, 3-24 chars, lowercase letters and numbers only
STORAGE_ACCOUNT_NAME="tfstate${RANDOM}${RANDOM}"
CONTAINER_NAME="tfstate"

echo "Creating resource group: ${RESOURCE_GROUP_NAME} in ${LOCATION}"
az group create \
	--name "${RESOURCE_GROUP_NAME}" \
	--location "${LOCATION}" \
	-o none

echo "Creating storage account: ${STORAGE_ACCOUNT_NAME}"
az storage account create \
	--name "${STORAGE_ACCOUNT_NAME}" \
	--resource-group "${RESOURCE_GROUP_NAME}" \
	--location "${LOCATION}" \
	--sku Standard_LRS \
	--kind StorageV2 \
	-o none

echo "Retrieving storage account key"
ACCOUNT_KEY=$(az storage account keys list \
	--resource-group "${RESOURCE_GROUP_NAME}" \
	--account-name "${STORAGE_ACCOUNT_NAME}" \
	--query "[0].value" -o tsv)

echo "Creating blob container: ${CONTAINER_NAME}"
az storage container create \
	--name "${CONTAINER_NAME}" \
	--account-name "${STORAGE_ACCOUNT_NAME}" \
	--account-key "${ACCOUNT_KEY}" \
	--public-access off \
	-o none

echo "\nBackend resources created:"
echo "- Resource Group: ${RESOURCE_GROUP_NAME}"
echo "- Storage Account: ${STORAGE_ACCOUNT_NAME}"
echo "- Container: ${CONTAINER_NAME}"

echo "\nUse this backend configuration in Terraform (backend.tf):"
cat <<EOF
terraform {
	backend "azurerm" {
		resource_group_name  = "${RESOURCE_GROUP_NAME}"
		storage_account_name = "${STORAGE_ACCOUNT_NAME}"
		container_name       = "${CONTAINER_NAME}"
		key                  = "terraform.tfstate"
	}
}
EOF