terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.66.0"
    }
  }
}

provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}


resource "aws_instance" "example" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "meuprimeirobucketralph" {
  bucket = "tcbblops"
  acl    = "private"
}


provider   "azurerm"   { 
   features   {} 
 } 

 resource   "azurerm_resource_group"   "rg"   { 
   name   =   "my-first-terraform-rg" 
   location   =   "eastus2" 
 } 

 resource   "azurerm_virtual_network"   "myvnet"   { 
   name   =   "myvnet" 
   address_space   =   [ "10.0.0.0/16" ] 
   location   =   "eastus2" 
   resource_group_name   =   azurerm_resource_group.rg.name 
 } 

 resource   "azurerm_subnet"   "frontendsubnet"   { 
   name   =   "frontendSubnet" 
   resource_group_name   =    azurerm_resource_group.rg.name 
   virtual_network_name   =   azurerm_virtual_network.myvnet.name 
   address_prefix   =   "10.0.1.0/24" 
 } 

 resource   "azurerm_public_ip"   "myvm1publicip"   { 
   name   =   "pip1" 
   location   =   "eastus2" 
   resource_group_name   =   azurerm_resource_group.rg.name 
   allocation_method   =   "Dynamic" 
   sku   =   "Basic" 
 } 

 resource   "azurerm_network_interface"   "myvm1nic"   { 
   name   =   "myvm1nic" 
   location   =   "eastus2" 
   resource_group_name   =   azurerm_resource_group.rg.name 

   ip_configuration   { 
     name   =   "ipconfig1" 
     subnet_id   =   azurerm_subnet.frontendsubnet.id 
     private_ip_address_allocation   =   "Dynamic" 
     public_ip_address_id   =   azurerm_public_ip.myvm1publicip.id
   }   
 }

 resource   "azurerm_virtual_machine"   "example"   { 
   name                    =   "myvm1"   
   location                =   "eastus2" 
   resource_group_name     =   azurerm_resource_group.rg.name 
   network_interface_ids   =   [azurerm_network_interface.myvm1nic.id]
   vm_size                    =   "Standard_B1s" 

   
   os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  
  os_profile_windows_config {
    timezone = "SA Pacific Standard Time"
  }

  storage_image_reference   { 
     publisher   =   "MicrosoftWindowsServer" 
     offer       =   "WindowsServer" 
     sku         =   "2019-Datacenter" 
     version     =   "latest" 
   } 

   storage_os_disk   { 
     name                =   "MyOSDisk"
	 create_option       =   "FromImage"
	 caching             =   "ReadWrite" 
     managed_disk_type   =   "Standard_LRS" 
   } 
   
 }