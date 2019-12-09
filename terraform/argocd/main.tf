resource "kubernetes_namespace" "argocd_ns" {
  metadata {
    name = "argocd"
  }
}

resource "null_resource" "argocd_deployment" {
  triggers = {
    always = timestamp()
  }

  provisioner "local-exec" {
    command     = "kubectl apply -n ${kubernetes_namespace.argocd_ns.metadata[0].name} -f ${var.argocd_install_yaml}"

    environment = {
      KUBECONFIG = var.kubeconfig_path
    }
  }
}

resource "kubernetes_ingress" "argocd_ingress" {
  metadata {
    name = "argocd-server-ingress"
    namespace = kubernetes_namespace.argocd_ns.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/ssl-passthrough" = "true"
      "nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS"
    }
  }
  spec {
    backend {
        service_name = "argocd-server"
        service_port = "https"
    }
  }
}
