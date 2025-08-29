## Day 15 — Azure VNet Peering (Mini Project)

This project provisions a simple, private lab to validate connectivity over Azure VNet peering:

- One resource group (`rg-day15`).
- Two virtual networks with subnets:
	- `peer1-vnet` (10.0.0.0/16) with `peer1-subnet` (10.0.0.0/24).
	- `peer2-vnet` (10.1.0.0/16) with `peer2-subnet` (10.1.0.0/24).
- Bidirectional VNet peerings (`vnet1-to-vnet2`, `vnet2-to-vnet1`) with forwarded traffic allowed.
- Two Ubuntu Linux VMs (one per subnet) created via count/count.index with matching NICs; no public IPs by default.

You can place both VNets in the same region or different regions. This is useful for testing private connectivity, routing, and peering behavior.

### Files
- `provider.tf`: Provider requirements (AzureRM ~> 3.x).
- `variables.tf`: Deployment region and VM size inputs (plus optional per‑VNet locations).
- `network.tf`: Resource group, VNets, subnets, and peerings.
- `vm.tf`: NICs and VMs using `count` and `count.index` to target each subnet.
- `backend.tf`: Optional remote backend (configure as needed).

### Inputs (key variables)
- `location` (string): Default deployment region (default: `canadaeast`).
- `vnet1_location` / `vnet2_location` (string, optional): Override per‑VNet region; falls back to `location`.
- `vm_size` (string): VM size (default: `Standard_B2s`).

### Quick start
```bash
tf init -reconfigure
tf plan  -var "location=canadacentral" -var "vm_size=Standard_B2s"
tf apply -auto-approve -var "location=canadacentral" -var "vm_size=Standard_B2s"
```

Tip: If you previously created resources with the same names, either import them into state or rename in HCL to avoid conflicts.

### Accessing the VMs
- Recommended: Use Azure Bastion in `peer1-vnet` (create an `AzureBastionSubnet` /27 and a Standard public IP, then an `azurerm_bastion_host`).
- Alternatively, add temporary public IPs/NAT only for testing (not included by default).

### Clean up
```bash
tf destroy -auto-approve -var "location=canadacentral" -var "vm_size=Standard_B2s"
```

