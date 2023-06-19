terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.57.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aks_rg_1" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr-1" {
  name                = "contregistry1tbkrgb"
  resource_group_name = azurerm_resource_group.aks_rg_1.name
  location            = azurerm_resource_group.aks_rg_1.location
  sku                 = "Basic"
  admin_enabled       = false
}

#CREATE AKS CLUSTER
resource "azurerm_kubernetes_cluster" "aks-1" {
  name                = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  location            = azurerm_resource_group.aks_rg_1.location
  resource_group_name = azurerm_resource_group.aks_rg_1.name
  dns_prefix          = var.cluster_name
  node_resource_group = var.node_resource_group
  
  default_node_pool {
    name                = "system"
    node_count          = var.system_node_count
    vm_size             = "Standard_DS2_v2"
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = false
  }

  identity {
    type = "SystemAssigned"
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "1m"
  }

  network_profile {
    network_plugin     = var.network_plugin
    load_balancer_sku  = "standard"
    docker_bridge_cidr = var.docker_bridge_cidr
    service_cidr       = var.service_cidr
    dns_service_ip     = var.dns_service_ip
  }

  tags = {
    Environment = "Develop"
  }
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "node_rg" {
  depends_on = [
    azurerm_kubernetes_cluster.aks-1
  ]
  name = var.node_resource_group
}

resource "azurerm_role_assignment" "ra-1" {
  principal_id                     = azurerm_kubernetes_cluster.aks-1.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr-1.id
  skip_service_principal_aad_check = true
}

resource "azurerm_key_vault" "aks_kv" {
  name                        = "akv-tbk-1"
  resource_group_name         = azurerm_resource_group.aks_rg_1.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  location                    = azurerm_resource_group.aks_rg_1.location

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx"
    certificate_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "ManageContacts",
      "ManageIssuers",
      "GetIssuers",
      "ListIssuers",
      "SetIssuers",
      "DeleteIssuers",
      "Purge"
    ]
    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Purge"
    ]
    key_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Encrypt",
      "Decrypt",
      "UnwrapKey",
      "WrapKey",
      "Verify",
      "Sign",
      "Purge"
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_kubernetes_cluster.aks-1.kubelet_identity[0].object_id

    key_permissions = [
      "Get",
      "List"
    ]

    secret_permissions = [
      "Get",
      "List"
    ]

    certificate_permissions = [
      "Get",
      "List"
    ]
  }

}

output "aks_managed_id" {
  value = azurerm_kubernetes_cluster.aks-1.kubelet_identity[0].object_id
}