variable "project_name" {
  type = string
}

variable "location" {
  type = string
}

variable "admin_login" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "environment" {
  description = "Deployment environment (dev/staging/prod)"
  type        = string
  default     = "dev"
}

variable "kubernetes_version" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "Development"
    Project     = "Ingatlan Piac"
    Owner       = "DevOps"
  }
}