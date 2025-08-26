locals {
  current_time = timestamp()
}

# Generate a random name for the load balancer
resource "random_pet" "lb_name" {
  separator = "-"
}

# Generate stable suffixes for DNS labels bound to region + RG name to avoid drifting
resource "random_string" "lb_dns" {
  length  = 6
  upper   = false
  special = false
  keepers = {
    region = var.location
    rg     = var.rg_name
  salt   = var.dns_label_salt
  }
}

resource "random_string" "nat_dns" {
  length  = 6
  upper   = false
  special = false
  keepers = {
    region = var.location
    rg     = var.rg_name
  salt   = var.dns_label_salt
  }
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
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
  name                = "lb-public-ip-${random_pet.lb_name.id}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones              = var.zones
  domain_name_label  = (var.enable_lb_dns_label || var.enable_dns_labels) ? coalesce(var.lb_domain_name_label, lower(replace("${var.rg_name}-${random_string.lb_dns.result}-lb", "_", "-"))) : null

  lifecycle {
    create_before_destroy = true
  }
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

  lifecycle {
    create_before_destroy = true
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
  name                = "nat-gw-public-ip-${random_pet.lb_name.id}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones              = var.zones
  domain_name_label  = (var.enable_nat_dns_label || var.enable_dns_labels) ? coalesce(var.nat_domain_name_label, lower(replace("${var.rg_name}-${random_string.nat_dns.result}-nat-gw", "_", "-"))) : null

  lifecycle {
    create_before_destroy = true
  }
}

# nat gateway resource with idle timeout and zone redundancy
resource "azurerm_nat_gateway" "nat_gw" {
  name                = "nat-gateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Standard"
  idle_timeout_in_minutes = 4
  zones              = var.zones
}

resource "azurerm_subnet_nat_gateway_association" "subnet_nat_assoc" {
  subnet_id      = azurerm_subnet.subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
}

# additional association for the NAT gateway with the public IP
resource "azurerm_nat_gateway_public_ip_association" "nat_gw_pip_assoc" {
  public_ip_address_id = azurerm_public_ip.nat_gw_pip.id
  nat_gateway_id       = azurerm_nat_gateway.nat_gw.id

  lifecycle {
    create_before_destroy = true
  }
}