locals {
  controls_by_service_eventgrid_common_tags = merge(local.controls_by_service_common_tags, {
    service = "Azure/EventGrid"
  })
}

benchmark "controls_by_service_eventgrid" {
  title       = "Event Grid"
  description = "This section contains recommendations for configuring Event Grid resources."
  children = [
    control.eventgrid_domain_identity_provider_enabled,
    control.eventgrid_domain_private_link_used,
    control.eventgrid_domain_restrict_public_access,
    control.eventgrid_topic_identity_provider_enabled,
    control.eventgrid_topic_local_auth_enabled,
    control.eventgrid_topic_private_link_used
  ]

  tags = merge(local.controls_by_service_eventgrid_common_tags, {
    type = "Benchmark"
  })
}
