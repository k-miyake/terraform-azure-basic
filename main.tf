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
  location = "westus2"
}

// ストレージアカウント
resource "azurerm_storage_account" "default" {
  name                     = "sttfazuredemo"
  resource_group_name      = azurerm_resource_group.default.name
  location                 = azurerm_resource_group.default.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "default" {
  name                = "plan-tfazure-demo"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "default" {
  name                       = "func-tfazure-demo"
  location                   = azurerm_resource_group.default.location
  resource_group_name        = azurerm_resource_group.default.name
  app_service_plan_id        = azurerm_app_service_plan.default.id
  storage_account_name       = azurerm_storage_account.default.name
  storage_account_access_key = azurerm_storage_account.default.primary_access_key
}
