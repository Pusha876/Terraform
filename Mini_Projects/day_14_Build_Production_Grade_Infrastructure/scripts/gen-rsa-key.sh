#!/usr/bin/env bash
set -euo pipefail

mkdir -p ./ssh

KEY_BASE="./ssh/id_rsa"
if [[ -f "${KEY_BASE}" && -f "${KEY_BASE}.pub" ]]; then
  echo "RSA key already exists at ${KEY_BASE}.pub"
  exit 0
fi

echo "Generating RSA 4096-bit key at ${KEY_BASE}"
ssh-keygen -t rsa -b 4096 -C "vmss" -f "${KEY_BASE}" -N ""
echo "Done. Use with: -var=\"ssh_public_key_path=${KEY_BASE}.pub\""
