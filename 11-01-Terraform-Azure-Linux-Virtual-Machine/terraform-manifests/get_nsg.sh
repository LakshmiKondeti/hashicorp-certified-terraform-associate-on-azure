#!/bin/bash

# Ensure required environment variables are set
if [[ -z "$ARM_CLIENT_ID" || -z "$ARM_CLIENT_SECRET" || -z "$ARM_TENANT_ID" || -z "$ARM_SUBSCRIPTION_ID" ]]; then
  echo '{"error": "Missing required environment variables"}'
  exit 1
fi

# Login to Azure using service principal
az login --service-principal -u "$ARM_CLIENT_ID" -p "$ARM_CLIENT_SECRET" --tenant "$ARM_TENANT_ID" >/dev/null 2>&1

# Set subscription
az account set --subscription "$ARM_SUBSCRIPTION_ID"

# Fetch NSG details (Optional: Filter by resource group if provided)
if [[ -n "$RESOURCE_GROUP" ]]; then
  NSG_JSON=$(az network nsg list --resource-group "$RESOURCE_GROUP" --query '[].{name:name, location:location}' -o json)
else
  NSG_JSON=$(az network nsg list --query '[].{name:name, location:location, resourceGroup:resourceGroup}' -o json)
fi

# Return JSON output
echo "{\"nsgs\": $NSG_JSON}"
