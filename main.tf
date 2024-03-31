provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "ncpl-rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "ncpl-vn" {
  name                = var.vn_name
  resource_group_name = azurerm_resource_group.ncpl-rg.name
  location            = azurerm_resource_group.ncpl-rg.location
  address_space       = ["10.0.0.0/16"]
}


resource "azurerm_subnet" "ncpl-subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.ncpl-rg.name
  virtual_network_name = azurerm_virtual_network.ncpl-vn.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "ncpl-nic" {
  name                = var.nic_name
  location            = azurerm_resource_group.ncpl-rg.location
  resource_group_name = azurerm_resource_group.ncpl-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ncpl-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "ncpl-vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.ncpl-rg.name
  location            = azurerm_resource_group.ncpl-rg.location
  size                = "Standard_F2"
  admin_username        = "adminuser"  # Replace with your desired admin username
  disable_password_authentication = false
  admin_password        = "MyStrongPassword123!"  # Replace with your desired admin password

  admin_ssh_key {
    username   = "adminuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAB..."
  }

  network_interface_ids = [
    azurerm_network_interface.ncpl-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
