# Day 18 — Azure Functions (Linux)

Short guide to provision the Function App with Terraform, run the function locally, and deploy code.

## Prerequisites
- Terraform >= 1.5
- Azure CLI authenticated (az login) and correct subscription selected (az account set -s <id>)
- Azure Functions Core Tools v4
- Node.js 18 LTS (runtime matches this project)

## 1) Provision infrastructure (Terraform)
From this folder:

```bash
tf init -reconfigure
tf validate
tf plan
tf apply --auto-approve
```

What it creates:
- Resource Group (Canada Central)
- Storage Account (for Functions state)
- Linux Consumption Plan (Y1)
- Linux Function App (Functions v4, Node 18)

Note: The Function App and Storage names include a random suffix to ensure global uniqueness.

## 2) Run locally (Functions Core Tools)
Change into the function project folder and start the host:

```bash
cd azure-qr-code/qrCodeGenerator
func start
```

Open the printed URL to invoke your function (or use curl/Postman).

## 3) Deploy code to Azure
Publish the local function to the Function App created by Terraform:

```bash
func azure functionapp publish <FUNCTION_APP_NAME>
```

Tip: The app name follows the pattern `example-linux-function-app-<suffix>`. You can confirm it in the Azure Portal (Resource Group created above).

## 4) Clean up
Destroy the Azure resources created by Terraform when done:

```bash
tf destroy --auto-approve
```

## Troubleshooting
- State lock errors: re-try after a minute or run `tf force-unlock -force <LOCK_ID>` if no run is active.
- Name conflicts: resource names are suffixed; if you still hit a collision, re-run `tf apply` or adjust the name prefix in `main.tf`.
