// Terraform Cloud を利用する設定
terraform {
  backend "remote" {
    organization = "k-miyake"

    workspaces {
      name = "terraform-azure-basic"
    }
  }
}

// Azure Provider の設定
provider "azurerm" {
  version = "~>2.0"
  features {}
}

// リソースグループ
resource "azurerm_resource_group" "default" {
  name     = "rg-tfazure-demo"
  location = "japaneast"
}
