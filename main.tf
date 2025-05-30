provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

provider "kubernetes" {
  host                   = module.aks.kube_config.0.host
  client_certificate     = base64decode(module.aks.kube_config.0.client_certificate)
  client_key             = base64decode(module.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(module.aks.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = module.aks.kube_config.0.host
    client_certificate     = base64decode(module.aks.kube_config.0.client_certificate)
    client_key             = base64decode(module.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(module.aks.kube_config.0.cluster_ca_certificate)
  }
}

resource "time_sleep" "wait_for_kubernetes" {
  depends_on = [module.aks]
  create_duration = "30s"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location
  tags     = var.tags
}

# AKS modul meghívása
module "aks" {
  source              = "./modules/aks"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  project_name        = var.project_name
  environment         = var.environment
  kubernetes_version  = var.kubernetes_version
}

# SQL Database modul meghívása
module "sql" {
  source              = "./modules/sql"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  project_name        = var.project_name
  environment         = var.environment
  admin_login         = var.admin_login
  admin_password      = var.admin_password
}

# Nginx Ingress Module
module "nginx_ingress" {
  source              = "./modules/nginx-ingress"
  depends_on          = [time_sleep.wait_for_kubernetes]
  resource_group_name = azurerm_resource_group.rg.name
  aks_cluster_id      = module.aks.cluster_id
  project_name        = var.project_name
}
