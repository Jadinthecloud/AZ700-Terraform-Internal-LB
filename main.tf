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
  location = "West US 2"
}