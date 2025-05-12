terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0, < 4.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10.0"
    }
  }

  # Opcionális backend konfiguráció - pl. state fájl tárolásához Azure Storage-ban
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "realestateterraformstate"
    container_name       = "tfstate"
    key                  = "azure.terraform.tfstate"
  }
}