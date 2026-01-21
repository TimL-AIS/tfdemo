# Resource Group
resource "azurerm_resource_group" "demo" {
  name     = "rg-tl-demo-1"
  location = "East US"
}

# Storage Account
# Note: Azure storage account names must be 3-24 characters, lowercase letters and numbers only
# "sa-tl-demo-1" is invalid, using "satldemo1" instead
resource "azurerm_storage_account" "demo" {
  name                     = "satldemo1"
  resource_group_name      = azurerm_resource_group.demo.name
  location                 = azurerm_resource_group.demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Blob Container
resource "azurerm_storage_container" "demo" {
  name                  = "container1"
  storage_account_name  = azurerm_storage_account.demo.name
  container_access_type = "private"
}

# Virtual Network
resource "azurerm_virtual_network" "demo" {
  name                = "vnet-demo"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
}

# Subnet
resource "azurerm_subnet" "demo" {
  name                 = "subnet-demo"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "demo" {
  name                = "nsg-demo"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    destination_address_prefix = "*"
    source_address_prefix      = "*"
  }
}

# Public IP
resource "azurerm_public_ip" "demo" {
  name                = "pip-demo"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Interface
resource "azurerm_network_interface" "demo" {
  name                = "nic-demo"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.demo.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.demo.id
  }
}

# Associate NSG with NIC
resource "azurerm_network_interface_security_group_association" "demo" {
  network_interface_id      = azurerm_network_interface.demo.id
  network_security_group_id = azurerm_network_security_group.demo.id
}

# SSH Key
resource "tls_private_key" "demo" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Ubuntu VM
resource "azurerm_linux_virtual_machine" "demo" {
  name                = "vm-demo-ubuntu"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.demo.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.demo.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]

    connection {
      type        = "ssh"
      user        = var.admin_username
      private_key = tls_private_key.demo.private_key_pem
      host        = azurerm_public_ip.demo.ip_address
    }
  }
}
