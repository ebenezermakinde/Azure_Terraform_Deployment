provider "azurerm" {
    version = "~>2.0"
    features {}
}

resource "azurerm_resource_group" "myrg" {
    name     = var.resourcegroup
    location = var.region

    tags = {
        environment = var.myTags[2]
    }
}

# Create App Service Plan
resource "azurerm_app_service_plan" "myappservice" {
    name                = "codewebby234ASP"
    location            = azurerm_resource_group.myrg.location
    resource_group_name = azurerm_resource_group.myrg.name

    sku {
        tier = "Standard"
        size = "S1"
    }

    tags = {
        enviroment = var.myTags[0]
    }
}

# Create Application Insights
resource "azurerm_application_insights" "appinsight" {
    name                = var.funcAppName[0]
    location            = azurerm_resource_group.myrg.location
    resource_group_name = azurerm_resource_group.myrg.name
    application_type = "web"

}

output "instrumentation_key" {
    value = azurerm_application_insights.appinsight.instrumentation_key
}

output "app_id" {
    value = azurerm_application_insights.appinsight.app_id
}

# Create Storage account
resource "azurerm_storage_account" "mystorage" {
    name = var.funcAppName[0]
    location = azurerm_resource_group.myrg.location
    resource_group_name = azurerm_resource_group.myrg.name
    account_tier = "Standard"
    account_replication_type = "LRS"
    account_kind = "StorageV2"

    tags = {
        environment = var.myTags[0]
    }

}

output "primary_connection_string" {
    value = azurerm_storage_account.mystorage.primary_connection_string
}

resource "azurerm_function_app" "myfuncApp1" {
    name = var.funcAppName[0]
    location                   = azurerm_resource_group.myrg.location
    resource_group_name        = azurerm_resource_group.myrg.name
    app_service_plan_id        = azurerm_app_service_plan.myappservice.id
    storage_account_name       = azurerm_storage_account.mystorage.name
    storage_account_access_key = azurerm_storage_account.mystorage.primary_access_key
    client_affinity_enabled    = false
    version = "~3"

    site_config {
        always_on = true
    }

    app_settings = {
        "APPINSIGHTS_INSTRUMENTATIONKEY"             = azurerm_application_insights.appinsight.instrumentation_key
        "APPLICATIONINSIGHTS_CONNECTION_STRING"      = "${var.insight_set}${azurerm_application_insights.appinsight.instrumentation_key}"
        "ApplicationInsightsAgent_EXTENSION_VERSION" = "~2"
        "FUNCTIONS_WORKER_RUNTIME"                   = var.func_worker_runtime[0]
        "FUNCTIONS_EXTENSION_VERSION"                = "~3"
    }

     tags = {
        environment = var.myTags[0]
    }
}
