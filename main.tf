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

  subscription_id = "0ea79fff-4d8c-4687-8082-109098c41c25"

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

resource "azurerm_lb" "int-lb" {
  name                = "myIntLoadBalancer"
  location            = azurerm_resource_group.rgmain.location
  resource_group_name = azurerm_resource_group.rgmain.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                     = "LoadBalancerFrontEnd"
    subnet_id                = azurerm_subnet.Frontendsubnet.id
    private_ip_address_allocation    = "Dynamic"
  }

}

#configure lb backend pool as well as create health probe. This will tell me which server is currenltly healthy and which is not. This will be used to route traffic to the healthy server.

resource "azurerm_lb_backend_address_pool" "int-lb-backend-pool" {
  name                = "myBackendPool"
  loadbalancer_id     = azurerm_lb.int-lb.id
}

data "azurerm_network_interface" "vm1" {
  name                = "myVMnic1"
  resource_group_name = "IntLB-RGnew"
}

data "azurerm_network_interface" "vm2" {
  name                = "myVMnic2"
  resource_group_name = "IntLB-RGnew"
}

data "azurerm_network_interface" "vm3" {
  name                = "myVMnic3"
  resource_group_name = "IntLB-RGnew"
}

resource "azurerm_network_interface_backend_address_pool_association" "vm1" {
  network_interface_id    = data.azurerm_network_interface.vm1.id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.int-lb-backend-pool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "vm2" {
  network_interface_id    = data.azurerm_network_interface.vm2.id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.int-lb-backend-pool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "vm3" {
  network_interface_id    = data.azurerm_network_interface.vm3.id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.int-lb-backend-pool.id
}
resource "azurerm_lb_probe" "int-lb-health-probe" {
  name                = "myHealthProbe"
  loadbalancer_id     = azurerm_lb.int-lb.id
  protocol            = "Http"
  port                = 80
  interval_in_seconds = 15
  request_path        = "/"
  number_of_probes    = 3
}