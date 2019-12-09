resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "${var.cluster_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  dns_prefix          = "${var.dns_prefix}"
  kubernetes_version  = "1.15.5"

  linux_profile {
    admin_username = "zakal"
    ssh_key {
      key_data = "${file("${var.ssh_public_key_file}")}"
    }
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "Standard"
  }

  default_node_pool {
    name            = "default"
    node_count      = "${var.agent_count}"
    vm_size         = "Standard_D1_v2"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

}

resource "local_file" "kubeconfig" {
  content   = "${azurerm_kubernetes_cluster.k8s.kube_config_raw}"
  filename  = "${path.module}/kubeconfig"
}


//resource "azurerm_container_registry" "acr" {
//  name                     = "acrspinnakertest"
//  resource_group_name      = "${azurerm_resource_group.spinnaker_k8s.name}"
//  location                 = "${azurerm_resource_group.spinnaker_k8s.location}"
//  sku                      = "Basic"
//  admin_enabled
//}
