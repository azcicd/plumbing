provider "kubernetes" {
  config_path = var.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

resource "kubernetes_namespace" "ns" {
  metadata {
    name = "ingress"
  }
}

resource "helm_release" "nginx-ingress" {
  name      = "nginx-ingress"
  chart     = "stable/nginx-ingress"
  namespace = kubernetes_namespace.ns.id

  set {
    name = "conroller.replicaCount"
    value = "2"
  }

  set {
    name = "controller.extraArgs.enable-ssl-passthrough"
    value = ""
  }
}
