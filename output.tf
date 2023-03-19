output "law_resource_id" {
  value       = azurerm_log_analytics_workspace.law[*].id
  description = "The resource id for the Log Analytics Workspace"
}