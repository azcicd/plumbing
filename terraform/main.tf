provider "azurerm" {
  version = "~>1.5"
}


resource "azurerm_resource_group" "spinnaker_k8s" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}


resource "azurerm_kubernetes_cluster" "spinnaker-k8s" {
  name                = "${var.cluster_name}"
  location            = "${azurerm_resource_group.spinnaker_k8s.location}"
  resource_group_name = "${azurerm_resource_group.spinnaker_k8s.name}"
  dns_prefix          = "${var.dns_prefix}"

  linux_profile {
    admin_username = "zakal"
    ssh_key {
      key_data = "${file("${var.ssh_public_key}")}"
    }
  }

  agent_pool_profile {
    name            = "default"
    count           = "${var.agent_count}"
    vm_size         = "Standard_D1_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  tags = {
    Environment = "Engineering"
  }
}

provider "helm" {
  kubernetes {
    host      = "${azurerm_kubernetes_cluster.spinnaker-k8s.kube_config.0.host}"
    username  = "${azurerm_kubernetes_cluster.spinnaker-k8s.kube_config.0.username}"
    password  = "${azurerm_kubernetes_cluster.spinnaker-k8s.kube_config.0.password}"

    client_certificate      = "${base64decode(azurerm_kubernetes_cluster.spinnaker-k8s.kube_config.0.client_certificate)}"
    client_key              = "${base64decode(azurerm_kubernetes_cluster.spinnaker-k8s.kube_config.0.client_key)}"
    cluster_ca_certificate  = "${base64decode(azurerm_kubernetes_cluster.spinnaker-k8s.kube_config.0.cluster_ca_certificate)}"
  }
}

resource "helm_release" "spinnaker" {
  name  = "spinnaker"
  chart = "stable/spinnaker"
}

