/*
 * AKS modul változók
 */

variable "resource_group_name" {
  type        = string
}

variable "project_name" {
  description = "A projekt neve"
  type        = string
}

variable "environment" {
  description = "A környezet típusa (pl. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Az Azure régió, ahol az AKS klaszter létrejön"
  type        = string
}

variable "kubernetes_version" {
  description = "A Kubernetes verzió, amit használni szeretnénk"
  type        = string
}

variable "node_count" {
  description = "A Kubernetes node-ok száma"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "Az AKS node-ok VM mérete"
  type        = string
  default     = "Standard_D2_v2"
}

variable "tags" {
  type        = map(string)
  default     = {}
}