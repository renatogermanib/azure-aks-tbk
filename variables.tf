variable "kubernetes_version" {
  type = string
  description = "version of AKS, always check for versions available"
}

variable "cluster_name" {
  type = string
  description = "AKS cluster name"
}

variable "location" {
  type        = string
  description = "location of resources"
}

variable "resource_group_name" {
  type        = string
  description = "aks resource group"
}

variable "system_node_count" {
  type        = string
  description = "total number of nodes in aks node pool"
}

variable "network_plugin" {
  type        = string
  description = "Choose between kubenet and azure cni. Kubenet is default, AzureCNI is preffered."
}

variable "docker_bridge_cidr" {
  type        = string
  description = "Internal docker bridge network CIDR"
}

variable "service_cidr" {
  type        = string
  description = "Internal kubernetes services CIDR"
}

variable "dns_service_ip" {
  type        = string
  description = "AKS DNS IP for name resolutions"
}

variable "node_resource_group" {
  type        = string
  description = "AKS node pool resource group, this is different from cluster rg"
}