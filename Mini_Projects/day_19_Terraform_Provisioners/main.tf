# Resource Group
resource "azurerm_resource_group" "prov-rg" {
  name     = "provisioners-rg"
  location = "eastus2"
  
  tags = var.common_tags
}

# Virtual Network and Subnet
resource "azurerm_virtual_network" "main" {
  name                = "prov-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.prov-rg.location
  resource_group_name = azurerm_resource_group.prov-rg.name
  
  tags = var.common_tags
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.prov-rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "vm-nsg" {
  name                = "vm-nsg"
  location            = azurerm_resource_group.prov-rg.location
  resource_group_name = azurerm_resource_group.prov-rg.name

  security_rule {
    name                       = "HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  tags = var.common_tags
}

# Public IP
resource "azurerm_public_ip" "main" {
  name                = "prov-public-ip"
  location            = azurerm_resource_group.prov-rg.location
  resource_group_name = azurerm_resource_group.prov-rg.name
  allocation_method   = "Static"
  
  tags = var.common_tags
}

# Network Interface
resource "azurerm_network_interface" "main" {
  name                = "prov-nic"
  location            = azurerm_resource_group.prov-rg.location
  resource_group_name = azurerm_resource_group.prov-rg.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
  
  tags = var.common_tags
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.vm-nsg.id
}

resource "null_resource" "deployment_prep" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "echo 'Deployment started at ${timestamp()}' > deployment-${formatdate("YYYY-MM-DD-hhmm", timestamp())}.log"
    }
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "prov-vm" {
  name                = "prov-machine"
  resource_group_name = azurerm_resource_group.prov-rg.name
  location            = azurerm_resource_group.prov-rg.location
  size                = "Standard_B1s"

depends_on = [null_resource.deployment_prep]

  computer_name                   = "provvm"
  admin_username                  = "adminuser"
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.main.id]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  
  tags = var.common_tags

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install nginx -y",

      # Create a sample welcome page
      "echo '<html>Welcome to the Nginx server provisioned by Terraform!</html>' | sudo tee /var/www/html/index.html",

      # Ensure nginx is started and enabled on boot
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]

  connection {
      type        = "ssh"
      user        = "adminuser"
      private_key = file("~/.ssh/id_rsa")
      host        = azurerm_public_ip.main.ip_address
      port        = 22
      timeout     = "10m"
    }
  }

  provisioner "file" {
    source        = "config/sample.conf"
    destination   = "/home/adminuser/sample.conf"

    connection {
      type        = "ssh"
      user        = "adminuser"
      private_key = file("~/.ssh/id_rsa")
      host        = azurerm_public_ip.main.ip_address
      port        = 22
      timeout     = "10m"
    }

  }

}
