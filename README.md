```hcl
module "ai_foundry" {
  source = "./modules/azure-ai-foundry"

  name                = 
  resource_group_name = 
  location            = 

  deployments = {
    gpt01 = { model_name = "gpt-4.1",      capacity = 10 }
    gpt02 = { model_name = "gpt-4.1-mini", capacity = 20 }
  }
}
```


- Account `S0`, deployments default to `DataZoneStandard`. 
- **Endpoints:** `endpoint` is AzureRM's account endpoint; `foundry_endpoint` is
the Foundry service root; `openai_endpoint` is the Azure OpenAI root;
`openai_v1_endpoint` includes `/openai/v1/` for recent SDKs.

