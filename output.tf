output "kube_config" {
  value     = module.aks.kube_config_raw
  sensitive = true
}

output "kubernetes_cluster_name" {
  value = module.aks.cluster_name
}

output "sql_server_name" {
  value = module.sql.server_name
}

output "sql_database_name" {
  value = module.sql.database_name
}