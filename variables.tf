variable "environment" {
  type        = string
  description = "The name of the deployment environment for the resource."
}

variable "location" {
  type        = string
  description = "The Azure region where the `Log Analytics Workspace` resource will be provisioned."
}

variable "resource_count" {
  type        = number
  default     = 0
  description = "The number of diagnostic settings to provision."
}

variable "resource_group_name" {
  type        = string
  description = "The Azure resource group where the resources will be provisioned."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to apply to the resources."
}

### LAW (Log Analytics Workspace) ###
variable "create_law" {
  type        = bool
  default     = false
  description = "A flag to enable creating a `Log Analytics Workspace`."
}

variable "law_destination_type" {
  type        = string
  default     = "Dedicated"
  description = "Possible values are `AzureDiagnostics` and `Dedicated`. When set to `Dedicated`, logs sent to a `Log Analytics Workspace` will go into resource specific tables, instead of the legacy `AzureDiagnostics` table."
}

variable "law_name" {
  type        = string
  default     = "law"
  description = "The name to provide to the `Log Analytics Workspace` resource."
}

variable "law_retention_in_days" {
  type        = number
  default     = 7
  description = "The number of days to retain logs/metrics in days in the `Log Analytics Workspace`."
}

variable "law_sku" {
  type        = string
  default     = "PerGB2018"
  description = "The sku for the `Log Analytics Workspace`. Available options `PerGB2018`, `Standard`, or `Premium`."
}

### Telemetry ###
variable "law_resource_id" {
  type        = string
  default     = null
  description = "The `Log Analytics Workspace` resource id where the logs/metrics should be sent."
}

variable "log_categories" {
  type        = list(string)
  default     = []
  description = "A list of the log category types of a resource to send to the destination `Log Analytics Workspace`."
}

variable "metric_categories" {
  type        = list(string)
  default     = []
  description = "A list of the `Metric Categories` types of a resource to send to the destination `Log Analytics Workspace`."
}

variable "target_resource_ids" {
  type        = list(string)
  default     = []
  description = "A list of `ids` of an existing resource on which to configure `Diagnostic Settings`. Changing this forces a new resource to be created."
}