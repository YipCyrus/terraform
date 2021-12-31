provider "azurerm" {
  skip_provider_registration = "true"
  features {}
}

variable "resource_group_name" {}
variable "virtual_network_name" {}
variable "subnet_id" {}

resource "azurerm_subnet" "bastion_subnet" {
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name

  name             = "AzureBastionSubnet"
  address_prefixes = ["10.0.3.224/27"]
}

resource "azurerm_public_ip" "bastion_pip" {
  location            = "eastus"
  resource_group_name = var.resource_group_name

  name              = "bastionpip"
  allocation_method = "Static"
  sku               = "Standard"
}

resource "azurerm_bastion_host" "bastion_host" {
  location            = "eastus"
  resource_group_name = var.resource_group_name

  name = "bastionhost"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}

