locals {
  current_time = timestamp()
}

# Generate a random name for the load balancer
resource "random_pet" "lb_name" {
  separator = "-"
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "day14-app-rg"
  location = var.location
  tags     = local.common_tags
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "day14-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]

  tags = local.common_tags
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group for the subnet with three security rules (SSH, HTTP, HTTPS)
resource "azurerm_network_security_group" "nsg" {
  name                = "day14-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Allow Standard LB health probes
  security_rule {
    name                       = "Allow-HealthProbe-HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
    description                = "Allow health probes from Azure Load Balancer on port 80"
  }
  security_rule {
    name                       = "Allow-HealthProbe-HTTPS"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
    description                = "Allow health probes from Azure Load Balancer on port 443"
  }

  # Allow app traffic from the Internet to backend ports (traffic reaches via LB; NICs have no public IPs)
  security_rule {
    name                       = "Allow-HTTP-Internet"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
    description                = "Allow HTTP from Internet"
  }
  security_rule {
    name                       = "Allow-HTTPS-Internet"
    priority                   = 1011
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
    description                = "Allow HTTPS from Internet"
  }
  tags = local.common_tags

}

# Subnet with NSG association
resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Public IP for Load Balancer
resource "azurerm_public_ip" "lb_pip" {
  name                = "lb-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones              = ["1", "2", "3"]
  domain_name_label = "${azurerm_resource_group.rg.name}-${random_pet.lb_name.id}-lb"
}

# Load Balancer with frontend IP configuration and backend address pool
resource "azurerm_lb" "lb" {
  name                = "frontend-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "public-ip-config"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "backend-pool"
}

# setup Load Balancer rules and health probe
resource "azurerm_lb_rule" "http" {
  loadbalancer_id            = azurerm_lb.lb.id
  name                       = "http-rule"
  protocol                   = "Tcp"
  frontend_port              = 80
  backend_port               = 80
  frontend_ip_configuration_name = "public-ip-config"
  backend_address_pool_ids   = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                   = azurerm_lb_probe.http.id
}

resource "azurerm_lb_probe" "http" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "http-probe"
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}

# NAT rule for SSH access to VMs in the backend pool
resource "azurerm_lb_nat_rule" "ssh" {
  name                          = "ssh-nat-rule"
  resource_group_name           = azurerm_resource_group.rg.name
  loadbalancer_id               = azurerm_lb.lb.id
  protocol                      = "Tcp"
  frontend_ip_configuration_name = "public-ip-config"
  frontend_port                 = 22
  backend_port                  = 22
}

resource "azurerm_public_ip" "nat_gw_pip" {
  name                = "nat-gw-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones              = ["1"]
  domain_name_label = "${azurerm_resource_group.rg.name}-${random_pet.lb_name.id}-nat-gw"
}

# nat gateway resource with idle timeout and zone redundancy
resource "azurerm_nat_gateway" "nat_gw" {
  name                = "nat-gateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Standard"
  idle_timeout_in_minutes = 4
  zones              = ["1"]
}

resource "azurerm_subnet_nat_gateway_association" "subnet_nat_assoc" {
  subnet_id      = azurerm_subnet.subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
}

# additional association for the NAT gateway with the public IP
resource "azurerm_nat_gateway_public_ip_association" "nat_gw_pip_assoc" {
  public_ip_address_id = azurerm_public_ip.nat_gw_pip.id
  nat_gateway_id       = azurerm_nat_gateway.nat_gw.id
}