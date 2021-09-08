terraform {
  backend "azurerm" {
    resource_group_name  = "shaunpearsonstate"
    storage_account_name = "shaunpearsonstate"
    container_name       = "shaunpearsonstate"
    key                  = "shaunpearsondev.tfstate"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "website"
  location = "uksouth"
}

resource "azurerm_storage_account" "static_storage" {
  name                      = "shaunpearsondev"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"

  static_website {
    index_document = "index.html"
  }


}

data "cloudflare_zones" "all" {
  filter {

  }
}

resource "cloudflare_record" "verify_www" {
  zone_id = data.cloudflare_zones.all.zones[0].id
  name    = "asverify.www"
  value   = "asverify.${azurerm_storage_account.static_storage.primary_blob_host}"
  type    = "CNAME"
  proxied = false
}

resource "cloudflare_record" "www" {
  zone_id = data.cloudflare_zones.all.zones[0].id
  name    = "www"
  value   = azurerm_storage_account.static_storage.primary_web_host
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_page_rule" "redirect" {
  zone_id  = data.cloudflare_zones.all.zones[0].id
  target   = "*${data.cloudflare_zones.all.zones[0].name}/*"
  priority = 1

  actions {
    forwarding_url {
      status_code = 301
      url         = "https://${cloudflare_record.www.hostname}"
    }
  }
}

output "static_storage_name" {
  value = azurerm_storage_account.static_storage.name
}
