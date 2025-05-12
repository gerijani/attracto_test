# modules/nginx/variables.tf
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "aks_cluster_id" {
  description = "ID of the AKS cluster"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}