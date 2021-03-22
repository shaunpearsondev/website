provider "azurerm" {
  subscription_id = "20d652cb-1a12-4ba3-b652-86cf13399fe6"
  features {}
}

variable "cloudflare_token" {
  description = "token generated from https://dash.cloudflare.com/profile/api-tokens"
  sensitive   = true
  type        = string
}

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 2.0.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_token

}
