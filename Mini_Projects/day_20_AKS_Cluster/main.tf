resource "azurerm_resource_group" "aks_rg" {
  name     = var.rg_name
  location = var.location
  tags     = var.common_tags
}

module "ServicePrincipal" {
  source = "./modules/ServicePrincipal"
  service_principal_name = var.service_principal_name
  tags = var.common_tags
  depends_on = [
    azurerm_resource_group.aks_rg
  ]
}

resource "azurerm_role_assignment" "sp_role_assignment" {
  principal_id   = module.ServicePrincipal.service_principal_object_id
  role_definition_name = "Contributor"
  scope          = azurerm_resource_group.aks_rg.id

  depends_on = [
    module.ServicePrincipal
  ]
}

module "keyvault" {
  source                      = "./modules/keyvault"
  keyvault_name               = var.keyvault_name
  location                    = var.location
  resource_group_name         = azurerm_resource_group.aks_rg.name
  service_principal_name      = var.service_principal_name
  service_principal_object_id = module.ServicePrincipal.service_principal_object_id
  service_principal_tenant_id = module.ServicePrincipal.service_principal_tenant_id
  tags                        = var.common_tags

    depends_on = [
        azurerm_role_assignment.sp_role_assignment
    ]
}

resource "azurerm_key_vault_secret" "sp_client_id" {
  name         = "sp-client-id"
  value        = module.ServicePrincipal.client_id
  key_vault_id = module.keyvault.keyvault_id

  depends_on = [
    module.keyvault
  ]
}

# Create a Azure AKS Cluster
module "aks_cluster" {
  source                      = "./modules/aks"
  location                    = var.location
  resource_group_name         = var.rg_name
  service_principal_name      = var.service_principal_name
  ssh_public_key              = module.keyvault.ssh_public_key
  ssh_private_key_secret_id   = module.keyvault.ssh_private_key_secret_id
  client_id                   = module.ServicePrincipal.client_id
  client_secret               = module.ServicePrincipal.client_secret
  aks_tags                    = var.common_tags

  depends_on = [
    azurerm_key_vault_secret.sp_client_id
  ]
}

resource "local_file" "kubeconfig" {
  content  = module.aks_cluster.config
  filename = "./kubeconfig_${var.rg_name}.yaml"

  depends_on = [
    module.aks_cluster
  ]
}