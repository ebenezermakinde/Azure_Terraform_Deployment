variable "region" {
    type = string
    default = "westus2"
    description = "The region to deploy my azure resources"
}

variable "insight_set" {
    type = string
    default = "APPINSIGHTS_INSTRUMENTATIONKEY="
    description = "Application insight connection string"
}