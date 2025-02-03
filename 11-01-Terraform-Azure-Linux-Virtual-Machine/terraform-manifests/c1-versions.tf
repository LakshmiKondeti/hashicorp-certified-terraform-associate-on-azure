# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
    random = {
      source = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

# Provider Block
provider "azurerm" {
 features {}          
}


variable "ARM_CLIENT_ID" {
  description = "Azure Client ID"
  type        = string
}

variable "ARM_CLIENT_SECRET" {
  description = "Azure Client Secret"
  type        = string
  sensitive   = true
}

variable "ARM_TENANT_ID" {
  description = "Azure Tenant ID"
  type        = string
}

variable "ARM_SUBSCRIPTION_ID" {
  description = "Azure Subscription ID"
  type        = string
}


# Random String Resource
resource "random_string" "myrandom" {
  length = 6
  upper = false 
  special = false
  number = false   
}

data "external" "azure_nsg" {
  program = ["bash", "./get_nsg.sh"]

  query = {
    ARM_CLIENT_ID       = var.ARM_CLIENT_ID
    ARM_CLIENT_SECRET   = var.ARM_CLIENT_SECRET
    ARM_TENANT_ID       = var.ARM_TENANT_ID
    ARM_SUBSCRIPTION_ID = var.ARM_SUBSCRIPTION_ID
    RESOURCE_GROUP      = azurerm_resource_group.myrg.name  # Optional: Pass a resource group filter
  }
}

output "nsg_details" {
  value = data.external.azure_nsg.nsgs
}



