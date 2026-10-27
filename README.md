```hcl
module "ai_foundry" {
  source = "./modules/azure-ai-foundry"

  name                = "foundry-myapp-prod-unique"
  resource_group_name = "myapp-prod-rg"
  location            = "westeurope"

  deployments = {
    chat = { model_name = "gpt-4.1",      capacity = 10 }
    fast = { model_name = "gpt-4.1-mini", capacity = 20 }
  }
}
```

Map keys (`chat`, `fast`) become Azure deployment names, not the underlying
model names. Use the deployment name in the app's `model` field.

For app-module integration:

```hcl
module "my_app" {
  source             = "./modules/my-app"
  foundry_endpoint   = module.ai_foundry.openai_v1_endpoint
  foundry_api_key    = module.ai_foundry.api_key
  foundry_deployment = module.ai_foundry.deployment_names["chat"]
}
```

**SKUs:** Account `S0`, deployments default to `DataZoneStandard`. Keep the
Foundry account in an EU data-zone region if EU inference processing is
required; do **not** override to `GlobalStandard` when that requirement applies.
Non-regional/global SKUs are rejected by default; to deliberately opt out, set
`allow_global_deployments = true`. This safety switch does not validate that
the account `location` is in an EU data-zone Azure region.
Data Zone isn't a guarantee that inference stays solely within `westeurope`.

**Quota:** `capacity` is an Azure SKU capacity unit, NOT universally `1000 TPM`.
Some Azure OpenAI model families have a different TPM and RPM ratio per unit.
Check quota for your model and region before choosing capacity.
Azure enforces model/region/SKU support and your subscription quota at apply.
`version_upgrade_option` defaults to `OnceCurrentVersionExpired`. Specify
`model_version` for deterministic initial versions, if desired.

**Endpoints:** `endpoint` is AzureRM's account endpoint; `foundry_endpoint` is
the Foundry service root; `openai_endpoint` is the Azure OpenAI root;
`openai_v1_endpoint` includes `/openai/v1/` for recent SDKs.

**Security:** `api_key` is sensitive in Terraform output, but is **still stored
in Terraform state**. Keep the remote backend access-controlled. API keys are
account-wide, not per-deployment least-privilege credentials. For prod app
access consider Entra ID and a role assignment such as
`Cognitive Services OpenAI User`, or fetch the shared key from Key Vault.
The module defaults to public network access; setting it to false requires a
working private endpoint and appropriate DNS. Endpoint access does not imply
public internet access when PNA is disabled.

The optional `project_name` creates a project with system-assigned identity;
projects are not required for basic model inference. Statefulness/Agent Service
may require additional dependent services and roles not included here.

