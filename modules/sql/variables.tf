/*
 * SQL modul változók
 */

variable "resource_group_name" {
  type        = string
}

variable "location" {
  type        = string
}

variable "project_name" {
  type        = string
}

variable "environment" {
  type        = string
}

variable "admin_login" {
  type        = string
}

variable "admin_password" {
  type        = string
  sensitive   = true
}

variable "database_sku" {
  type        = string
  default     = "Basic"
}

variable "tags" {
  type        = map(string)
  default     = {
    Environment = "Development"
    Project     = "IngatlanMarketplace"
  }
}