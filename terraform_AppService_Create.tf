# Use Azure provider
provider "azurerm" {
    version = "~>2.0"
    features {}
}

# Create Resource Group
resource "azurerm_resource_group" "myrg" {
    name     = "webAppRG"
    location = var.region

    tags = {
        enviroment = "WebApp resource"
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
        enviroment = "WebApp resource"
    }
}

# Create Application Insights
resource "azurerm_application_insights" "appinsight" {
    name                = "codeWebbyInsight"
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

# Create web app 
resource "azurerm_app_service" "myappservice" {
    name                    = "codewebby234apper"
    location                = azurerm_resource_group.myrg.location
    resource_group_name     = azurerm_resource_group.myrg.name
    app_service_plan_id     = azurerm_app_service_plan.myappservice.id
    client_affinity_enabled = false

    site_config {
        always_on = true
        default_documents = [
            "Default.htm",
            "Default.html",
            "Default.asp",
            "index.htm",
            "index.html",
            "iisstart.htm",
            "default.aspx",
            "index.php",
            "hostingstart.html"
        ]
        dotnet_framework_version = "v4.0"
        ftps_state = "AllAllowed"
        
    }

    app_settings = {
        "APPINSIGHTS_INSTRUMENTATIONKEY"             = azurerm_application_insights.appinsight.instrumentation_key
        "APPLICATIONINSIGHTS_CONNECTION_STRING"      = "${var.insight_set}${azurerm_application_insights.appinsight.instrumentation_key}"
        "ApplicationInsightsAgent_EXTENSION_VERSION" = "~2"
    }
 }