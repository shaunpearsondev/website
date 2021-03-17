# terraform {
#   backend "azurerm" {}
# }

resource "azurerm_resource_group" "rg" {
  name     = "website"
  location = "uksouth"
}

resource "azurerm_storage_account" "static_storage" {
  name                     = "shaunpearsondev"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_https_traffic_only = true 
  min_tls_version = "1.2"  

  static_website {
    index_document = "index.html"
  }
}