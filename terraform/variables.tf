variable "client_id" {
  default = ""
}
variable "client_secret" {
  default = ""
}

variable "agent_count" {
  default = 3
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
  default = "spinnaker-k8s"
}

variable cluster_name {
  default = "spinnaker-k8s"
}

variable resource_group_name {
  default = "spinnaker-k8stest"
}

variable location {
  default = "West Europe"
}

