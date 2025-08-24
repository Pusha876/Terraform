Day 13 - Data Sources

Notes:
- Backend now points to resource group tfstate-day04 and storage account tfstate1684828945, container tfstate.
- Provider uses azurerm ~> 3.0 to support legacy azurerm_virtual_machine in this example.
- Data sources expect a pre-existing RG/VNet/Subnet: shared-network-rg/shared-network-vnet/shared-primary-sn.
  Adjust names or create them before plan/apply.
