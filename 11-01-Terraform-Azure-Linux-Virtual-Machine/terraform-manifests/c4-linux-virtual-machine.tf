
variable "TF_ARM_CLIENT_ID" {
  description = "Azure Client ID"
  type        = string
}

variable "TF_ARM_CLIENT_SECRET" {
  description = "Azure Client Secret"
  type        = string
  sensitive   = true
}

variable "TF_ARM_TENANT_ID" {
  description = "Azure Tenant ID"
  type        = string
}

variable "TF_ARM_SUBSCRIPTION_ID" {
  description = "Azure Subscription ID"
  type        = string
}


# Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  name = "mylinuxvm-1"
  computer_name = "devlinux-vm1"  # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location = azurerm_resource_group.myrg.location
  size = "Standard_DS1_v2"
  admin_username = "azureuser"
  network_interface_ids = [ azurerm_network_interface.myvmnic.id ]
  admin_ssh_key {
    username = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name = "osdisk"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "RedHat"
    offer = "RHEL"
    sku = "83-gen2"
    version = "latest"
  }
  custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")
}


data "external" "azure_nsg" {
  program = ["bash", "./get_nsg.sh"]

  query = {
    ARM_CLIENT_ID       = var.TF_ARM_CLIENT_ID
    ARM_CLIENT_SECRET   = var.TF_ARM_CLIENT_SECRET
    ARM_TENANT_ID       = var.TF_ARM_TENANT_ID
    ARM_SUBSCRIPTION_ID = var.TF_ARM_SUBSCRIPTION_ID
    RESOURCE_GROUP      = azurerm_resource_group.myrg.name  # Optional: Pass a resource group filter
  }
}

output "nsg_details" {
  value = data.external.azure_nsg.nsgs
}
