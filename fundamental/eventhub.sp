locals {
  fundamental_security_eventhub_common_tags = {
    service = "Azure/EventHub"
  }
}

benchmark "fundamental_security_eventhub" {
  title       = "EventHub"
  description = "This section contains recommendations for configuring EventHub resources."
  children = [
    control.eventhub_namespace_cmk_encryption_enabled,
    control.eventhub_namespace_logging_enabled,
    control.eventhub_namespace_private_link_used,
    control.eventhub_namespace_use_virtual_service_endpoint
  ]
}