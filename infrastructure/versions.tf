provider "azurerm" {
  subscription_id = "1734896b-d491-4362-a143-77a3c6d8ef11"
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
