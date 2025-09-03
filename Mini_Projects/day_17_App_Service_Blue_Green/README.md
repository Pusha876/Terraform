# Day 17 — Azure App Service Blue/Green

This mini‑project shows a basic blue/green deployment setup for Azure App Service using Terraform.

## Purpose
- Provision a Linux App Service Plan and a Linux Web App
- Create a deployment slot (blue) for staged releases and safe swaps
- Optionally bind source control to the app and the slot
- Configure the runtime via `site_config` (e.g., .NET 6)

## Structure
- `backend.tf` — Remote state backend (Azure Storage). Use a unique `key` per project to avoid state conflicts.
- `provider.tf` — Terraform and provider versions; `azurerm` provider configuration.
- `variables.tf` — Input variables (e.g., `prefix`) for naming.
- `main.tf` — Core resources:
	- Resource Group
	- App Service Plan (Linux)
	- Linux Web App
	- Linux Web App Slot (blue)
	- Optional source control for app and slot

Notes
- Web App names are globally unique; a random suffix helps prevent collisions.
- The slot uses `azurerm_linux_web_app_slot` and mirrors app runtime settings.
- If SCM already exists in Azure, import those resources or remove them from Terraform to avoid conflicts.
