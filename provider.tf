terraform {
  required_version = "~>1.9.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.21.1"
    }
  }
  backend "azurerm" {
    resource_group_name  = "mtb-p-homelab-infra-tfstate-rg"
    storage_account_name = "mtbhomelabinfratfstatest"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

