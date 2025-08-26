This folder can hold project-local SSH keys for the VMSS.

Azure VMSS requires RSA keys (ssh-rsa). If you generated an ed25519 key, create an RSA key instead.

Recommended (Windows Git Bash):
- Generate RSA key: `ssh-keygen -t rsa -b 4096 -C "vmss" -f ./ssh/id_rsa -N ""`
- Use in Terraform: `-var="ssh_public_key_path=./ssh/id_rsa.pub"`

Helper script:
- Run: `bash ./scripts/gen-rsa-key.sh`
- This will create `./ssh/id_rsa` and `./ssh/id_rsa.pub` if they don’t exist.

Do not commit private keys.
