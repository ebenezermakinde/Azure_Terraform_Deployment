# Resource group name
variable "resourcegroup" {
    type = string
    default = "funcAppRG"
    description = "The function application resource group name"
}

# Default region
variable "region" {
    type = string
    default = "westus"
    description = "The default region to use for deployment"
}

# Allowed Tags
variable "myTags" {
    type = list(string)
    default = [
        "FunctionApp appServicePlan demo",
        "FunctionApp dynamicPlan demo",
        "FuncAppRG demo"
    ]
}

# Allowed function app names
variable "funcAppName" {
    type = list(string)
    default = [
        "codebugger234",
        "codebugger235"
    ]
}

# App Insight details
variable "insight_set" {
    type = string
    default = "Instrum="
    description = "Application insight connection string"
}

# Azure Function runtime versions
variable "func_worker_runtime" {
    type = list(string)
    default = [
        "dotnet",
        "python",
        "node",
        "java",
        "powershell"
    ]
    description = "The available function language worker runtime in Azure"
}