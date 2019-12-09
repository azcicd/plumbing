variable "argocd_install_yaml" {
  default = "https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
}

variable "kubeconfig_path" { }