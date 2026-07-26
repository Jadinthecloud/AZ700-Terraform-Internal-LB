terraform {
    
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.6"
}

provider "azurerm" {

  features {}

  subscription_id = "var.subscription_id"

}

resource "azurerm_resource_group" "rgmain" {
  name     = "IntLB-RGnew"
  location = "East US"
}

resource "azurerm_virtual_network" "int-vnet" {
    name = "intlb-vnet"
    resource_group_name = azurerm_resource_group.rgmain.name
    address_space = ["10.1.0.0/16"]
    location = "East US"
}

resource "azurerm_bastion_host" "int-bastion" {
  name                = "myBastionHost"
  resource_group_name = azurerm_resource_group.rgmain.name
  location            = azurerm_resource_group.rgmain.location
  sku                 = "Standard"
  
  #below must be in this order, otherwise it will throw an error
  ip_configuration {
    name = "bastion-ip-config"
    subnet_id = azurerm_subnet.bastion-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-pip.id
}

}

#bastion subnet
resource "azurerm_subnet" "bastion-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rgmain.name
  virtual_network_name = azurerm_virtual_network.int-vnet.name
  address_prefixes     = ["10.1.3.0/24"]
} 

#bastion pip
resource "azurerm_public_ip" "bastion-pip" {
  name                = "myBastionPublicIP"
  resource_group_name = azurerm_resource_group.rgmain.name
  location            = azurerm_resource_group.rgmain.location
  allocation_method   = "Static"
  sku                 = "Standard" 
}

#frontend +backend subnets
resource "azurerm_subnet" "BackendSubnet" {
    name                 = "myBackendSubnet"
    resource_group_name  = azurerm_resource_group.rgmain.name
    virtual_network_name = azurerm_virtual_network.int-vnet.name
    address_prefixes     = ["10.1.0.0/24"]
    default_outbound_access_enabled = false
}

resource "azurerm_subnet" "Frontendsubnet" {
    name                 = "myFrontendSubnet"
    resource_group_name  = azurerm_resource_group.rgmain.name
    virtual_network_name = azurerm_virtual_network.int-vnet.name
    address_prefixes     = ["10.1.2.0/24"]
}