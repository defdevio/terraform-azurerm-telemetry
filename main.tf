resource "azurerm_log_analytics_workspace" "law" {
  count               = var.create_law ? 1 : 0
  name                = "${var.environment}-${var.location}-${var.law_name}"
  resource_group_name = var.resource_group_name

  location          = var.location
  retention_in_days = var.law_retention_in_days
  sku               = var.law_sku
  tags              = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "telemetry" {
  count                          = var.resource_count
  name                           = "${var.environment}-${var.location}-diag"
  log_analytics_destination_type = var.law_destination_type
  log_analytics_workspace_id     = try(azurerm_log_analytics_workspace.law[0].id, var.law_resource_id)
  target_resource_id             = var.target_resource_ids[count.index]

  dynamic "enabled_log" {
    for_each = var.log_categories
    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = var.metric_categories
    content {
      category = metric.value
    }
  }
}