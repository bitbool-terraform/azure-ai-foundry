resource "azurerm_cognitive_account" "this" {
  name                = var.name
  resource_group_name = var.resource_group
  location            = var.location

  kind                       = "AIServices"
  sku_name                   = var.sku_name
  project_management_enabled = true
  custom_subdomain_name      = local.custom_subdomain_name

  local_auth_enabled             = true
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "network_acls" {
    for_each = length(var.whitelist_ips) > 0 ? [1] : []

    content {
      default_action = "Deny"
      bypass         = "None"
      ip_rules       = var.whitelist_ips
    }
  }  

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_cognitive_deployment" "this" {
  for_each = var.deployments

  name                 = each.key
  cognitive_account_id = azurerm_cognitive_account.this.id

  model {
    format  = each.value.model_format
    name    = each.value.model_name
    version = each.value.model_version
  }

  sku {
    name     = coalesce(each.value.sku_name, var.default_deployment_sku_name)
    capacity = each.value.capacity
  }

  version_upgrade_option = each.value.version_upgrade_option

  lifecycle {
    precondition {
      condition = var.allow_global_deployments || contains(
        ["DataZoneStandard", "DataZoneBatch", "DataZoneProvisionedManaged", "Standard", "ProvisionedManaged"],
        coalesce(each.value.sku_name, var.default_deployment_sku_name)
      )
      error_message = "A non-EU-residency deployment SKU is blocked. Use DataZoneStandard (default) or explicitly set allow_global_deployments=true."
    }
  }
}

resource "azurerm_cognitive_account_project" "this" {
  count = var.project_name == null ? 0 : 1

  name                 = var.project_name
  cognitive_account_id = azurerm_cognitive_account.this.id
  location             = var.location
  display_name         = coalesce(var.project_display_name, var.project_name)
  description          = var.project_description

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
