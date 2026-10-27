# Sample root module; assumes a configured azurerm provider and an existing RG.
module "ai_foundry" {
  source = "../.."

  name                = "foundry-myproject-prod-unique"
  resource_group_name = "myproject-prod-rg"
  location            = "westeurope"

  # Optional; no project is required for ordinary model inference.
  # project_name = "myproject-prod"

  deployments = {
    chat = {
      model_name = "gpt-4.1"
      capacity   = 10
      # model_version = "2025-04-14"  # Uncomment if this version is available.
    }
    fast = {
      model_name = "gpt-4.1-mini"
      capacity   = 20
      # sku_name = "DataZoneStandard"  # Already the default.
    }
  }

  tags = {
    environment = "prod"
    service     = "ai-foundry"
  }
}

output "foundry_openai_v1_endpoint" {
  value = module.ai_foundry.openai_v1_endpoint
}

output "foundry_model_deployments" {
  value = module.ai_foundry.deployment_names
}

# Avoid emitting this at your root unless you explicitly need to inspect it:
# output "foundry_api_key" {
#   value     = module.ai_foundry.api_key
#   sensitive = true
# }
