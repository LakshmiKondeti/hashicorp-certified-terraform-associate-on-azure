# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
  }
}


provider "azurerm" {
  subscription_id = "96b53eca-8f9d-475b-96d6-7f9539af0757"
  features {}
}


