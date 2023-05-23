# VPC Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

resource "flexibleengine_dns_zone_v2" "zones" {
  count       = length(var.zones)

  name        = element(var.zones.*.name, count.index)
  email       = element(var.zones.*.email, count.index) == null ? null : element(var.zones.*.email, count.index)
  description = element(var.zones.*.description, count.index) == null ? null : element(var.zones.*.description, count.index)
  ttl         = element(var.zones.*.ttl, count.index) == null ? null : element(var.zones.*.ttl, count.index)
  zone_type   = element(var.zones.*.zone_type, count.index) == null ? null : element(var.zones.*.zone_type, count.index)
  //value_specs   = element(var.zones.*.value_specs, count.index) == null ? {} : element(var.zones.*.value_specs, count.index)

  router {
    router_region = element(var.zones.*.router_region, count.index) == null ? null : element(var.zones.*.router_region, count.index)
    router_id     = element(var.zones.*.router_id, count.index) == null ? null : element(var.zones.*.router_id, count.index)
  }

  //tags = element(var.zones.*.tags, count.index) == null ? null : element(var.zones.*.tags, count.index)
}

resource "flexibleengine_dns_recordset_v2" "recordsets" {
  count       = length(var.zones)

  zone_id     = flexibleengine_dns_zone_v2.zones[count.index].id
  name        = "${var.zones[count.index].dns_recordsets[count.index].name}.${var.zones[count.index].domain_name}"
  description = var.zones[count.index].dns_recordsets[count.index].description == null ? null : var.zones[count.index].dns_recordsets[count.index].description
  ttl         = var.zones[count.index].dns_recordsets[count.index].ttl == null ? null : var.zones[count.index].dns_recordsets[count.index].ttl
  type        = var.zones[count.index].dns_recordsets[count.index].type
  records     = var.zones[count.index].dns_recordsets[count.index].records
  value_specs = var.zones[count.index].dns_recordsets[count.index].value_specs == null ? null : var.zones[count.index].dns_recordsets[count.index].value_specs
}
