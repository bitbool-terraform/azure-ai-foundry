variable "name" {
  description = "Name of the Foundry (AIServices) account; must be globally unique."
  type        = string
}

variable "resource_group" {
  description = "Name of an existing Azure resource group."
  type        = string
}

variable "location" {
  description = "Azure region, e.g. westeurope. Use a region in the EU data zone for EU processing."
  type        = string
  default     = "westeurope"
}

variable "sku_name" {
  type        = string
  default     = "S0"
}

variable "custom_subdomain_name" {
  description = "Globally unique custom subdomain. Defaults to the Foundry account name. Required for project/Entra/private endpoint support."
  type        = string
  default     = null
}

variable "public_network_access_enabled" {
  description = "Keep true unless networking and private endpoint/DNS are already configured."
  type        = bool
  default     = true
}

variable "default_deployment_sku_name" {
  description = "Default SKU for model deployments. DataZoneStandard keeps inference within the account's data zone."
  type        = string
  default     = "DataZoneStandard"
}

variable "allow_global_deployments" {
  description = "Safety switch: false rejects Global SKUs and other deployment SKUs not scoped to a data zone or Azure geography. It does not validate the account location."
  type        = bool
  default     = false
}

variable "deployments" {
  description = <<-EOT
    Model deployment map, keyed by the deployment alias applications will use.
    capacity is an Azure SKU capacity unit, *not* always a fixed TPM amount:
    the mapping to TPM/RPM depends on the specific model and deployment SKU.
    All example deployments use DataZoneStandard unless overridden.
  EOT

  type = map(object({
    model_name             = string
    model_version          = optional(string)
    model_format           = optional(string, "OpenAI")
    sku_name               = optional(string)
    capacity               = number
    version_upgrade_option = optional(string, "OnceCurrentVersionExpired")
  }))

  default = {}

  validation {
    condition = alltrue([
      for deployment in values(var.deployments) :
      deployment.capacity >= 1 && deployment.capacity == floor(deployment.capacity)
    ])
    error_message = "Each deployment.capacity must be a positive integer."
  }
}

variable "project_name" {
  description = "Optional Foundry project name. Null creates only the account and model deployments."
  type        = string
  default     = null
}

variable "project_display_name" {
  description = "Optional friendly name of the Foundry project."
  type        = string
  default     = null
}

variable "project_description" {
  description = "Optional Foundry project description."
  type        = string
  default     = null
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = {}
}

variable "whitelist_ips" {
  type    = list(string)
  default = []
}