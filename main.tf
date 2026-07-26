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

  subscription_id = "9a3bd440-e85e-4dc5-803f-76c12c6b5770"

}

resource "azurerm_resource_group" "rgmain" {
  name     = "IntLB-RGnew"
  location = "West US 2"
}