variable "resource_group_name" {
    description = "Name of Resource Group"
    type = string
}

variable "location" {
    description = "Name of location"
    type = string
}

variable "azurerm_app_service_plan" {
  description = "Name of the app service"
  type = string
}

variable "sku" {
    description = " type of tier"
    type = string
}

variable "size" {
    description = "size of tier"
    type = string
}

variable "ncpl_app_service" {
  description = "name of app service"
  type = string
  }
