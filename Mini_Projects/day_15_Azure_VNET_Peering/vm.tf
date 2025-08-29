locals {
  vm_prefixes = ["peer1", "peer2"]
  subnets     = [azurerm_subnet.subnet1.id, azurerm_subnet.subnet2.id]
}

resource "azurerm_network_interface" "nic" {
  count               = length(local.vm_prefixes)
  name                = "${local.vm_prefixes[count.index]}-nic"
  location            = azurerm_resource_group.rg-day15.location
  resource_group_name = azurerm_resource_group.rg-day15.name

  ip_configuration {
    name                          = "ipconfig${count.index}"
    subnet_id                     = local.subnets[count.index]
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [azurerm_subnet.subnet1, azurerm_subnet.subnet2]
}

resource "azurerm_virtual_machine" "vm" {
  count                = length(local.vm_prefixes)
  name                 = "${local.vm_prefixes[count.index]}-vm"
  location             = azurerm_resource_group.rg-day15.location
  resource_group_name  = azurerm_resource_group.rg-day15.name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  vm_size              = var.vm_size

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${local.vm_prefixes[count.index]}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${local.vm_prefixes[count.index]}"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "dev"
  }
}