variable location {}
variable client_id {}
variable client_secret {}
variable resource_group_name { }

variable agent_count {
  default = 3
}

variable ssh_public_key_file {
  default = "~/.ssh/id_rsa.pub"
}

variable dns_prefix {
  default = "k8s"
}

variable cluster_name {
  default = "k8s"
}


