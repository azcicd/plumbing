provider "azurerm" {
  version = "1.38.0"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "k8s" {
  source = "./k8s"

  agent_count         = "2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  client_secret       = var.client_secret
  client_id           = var.client_id
}

module "ingress" {
  source = "./ingress"

  kubeconfig_path = module.k8s.kube_config_path
}

module "argocd" {
  source = "./argocd"
  kubeconfig_path = module.k8s.kube_config_path
}

