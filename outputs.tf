output "id" {
  description = "Azure resource ID of the Foundry account."
  value       = azurerm_cognitive_account.this.id
}

output "name" {
  description = "Foundry account name."
  value       = azurerm_cognitive_account.this.name
}

output "endpoint" {
  description = "Account endpoint returned by AzureRM."
  value       = azurerm_cognitive_account.this.endpoint
}

output "foundry_endpoint" {
  description = "Foundry services API endpoint."
  value       = "https://${local.custom_subdomain_name}.services.ai.azure.com/"
}

output "openai_endpoint" {
  description = "Azure OpenAI base endpoint, compatible with legacy Azure OpenAI clients."
  value       = "https://${local.custom_subdomain_name}.openai.azure.com/"
}

output "openai_v1_endpoint" {
  description = "OpenAI v1-compatible base URL for SDKs and /responses or /chat/completions requests."
  value       = "https://${local.custom_subdomain_name}.openai.azure.com/openai/v1/"
}

output "api_key" {
  description = "Primary access key. Treat as a secret; stored in Terraform state."
  value       = azurerm_cognitive_account.this.primary_access_key
  sensitive   = true
}

output "deployment_names" {
  description = "Map of logical deployment keys to deployed names; pass these to applications."
  value       = { for key, deployment in azurerm_cognitive_deployment.this : key => deployment.name }
}

output "deployment_ids" {
  description = "Map of logical deployment keys to Azure deployment resource IDs."
  value       = { for key, deployment in azurerm_cognitive_deployment.this : key => deployment.id }
}

output "project_id" {
  description = "Optional Foundry project resource ID, or null when omitted."
  value       = try(azurerm_cognitive_account_project.this[0].id, null)
}

output "project_endpoints" {
  description = "API endpoints returned by Azure for the optional Foundry project."
  value       = try(azurerm_cognitive_account_project.this[0].endpoints, {})
}

output "identity_principal_id" {
  description = "Object ID of the Foundry account's system-assigned managed identity."
  value       = azurerm_cognitive_account.this.identity[0].principal_id
}
