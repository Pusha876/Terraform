#!/usr/bin/env bash
set -euo pipefail

# Creates a shared Resource Group, Virtual Network, and Subnet for Day-13 examples.
# Defaults match the Terraform data sources in main.tf
# Usage:
#   ./scripts/setup-shared-network.sh \
#     [-g shared-network-rg] [-l eastus] \
#     [-v shared-network-vnet] [-s shared-primary-sn] \
#     [-p 10.20.0.0/16] [-q 10.20.1.0/24]

RG_NAME="${RG_NAME:-shared-network-rg}"
LOCATION="${LOCATION:-eastus}"
VNET_NAME="${VNET_NAME:-shared-network-vnet}"
SUBNET_NAME="${SUBNET_NAME:-shared-primary-sn}"
VNET_CIDR="${VNET_CIDR:-10.20.0.0/16}"
SUBNET_CIDR="${SUBNET_CIDR:-10.20.1.0/24}"

while getopts ":g:l:v:s:p:q:h" opt; do
  case $opt in
    g) RG_NAME="$OPTARG" ;;
    l) LOCATION="$OPTARG" ;;
    v) VNET_NAME="$OPTARG" ;;
    s) SUBNET_NAME="$OPTARG" ;;
    p) VNET_CIDR="$OPTARG" ;;
    q) SUBNET_CIDR="$OPTARG" ;;
    h)
      echo "Usage: $0 [-g rg-name] [-l location] [-v vnet-name] [-s subnet-name] [-p vnet-cidr] [-q subnet-cidr]";
      exit 0
      ;;
    \?) echo "Invalid option -$OPTARG" >&2; exit 1 ;;
  esac
done

command -v az >/dev/null 2>&1 || { echo "Azure CLI 'az' is required" >&2; exit 1; }

echo "Ensuring resource group: $RG_NAME ($LOCATION)"
az group create -n "$RG_NAME" -l "$LOCATION" -o none

echo "Ensuring virtual network: $VNET_NAME in $RG_NAME"
if ! az network vnet show -g "$RG_NAME" -n "$VNET_NAME" -o none 2>/dev/null; then
  az network vnet create \
    -g "$RG_NAME" -n "$VNET_NAME" -l "$LOCATION" \
    --address-prefixes "$VNET_CIDR" \
    --subnet-name "$SUBNET_NAME" --subnet-prefixes "$SUBNET_CIDR" \
    -o none
else
  echo "VNet exists; ensuring subnet: $SUBNET_NAME"
  az network vnet subnet show -g "$RG_NAME" --vnet-name "$VNET_NAME" -n "$SUBNET_NAME" -o none 2>/dev/null \
    || az network vnet subnet create -g "$RG_NAME" --vnet-name "$VNET_NAME" -n "$SUBNET_NAME" --address-prefixes "$SUBNET_CIDR" -o none
fi

echo "Done. Summary:"
echo "  RG:    $RG_NAME ($LOCATION)"
echo "  VNet:  $VNET_NAME ($VNET_CIDR)"
echo "  Subnet:$SUBNET_NAME ($SUBNET_CIDR)"
