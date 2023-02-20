############
### Main ###
############

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.41.0"
    }
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~>3.14.0"
    }
  }

  backend "azurerm" {}
}

# Configure the Azure Provider
provider "azurerm" {}

# Configure the NR Provider
provider "newrelic" {
  account_id = var.NEW_RELIC_ACCOUNT_ID
  api_key    = var.NEW_RELIC_API_KEY
  region     = var.NEW_RELIC_REGION
}
#########
