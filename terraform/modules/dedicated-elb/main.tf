# Dedicate Elastic Load Balancer Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

data "flexibleengine_elb_flavors" "l7_flavors" {
  type = "L7"
}

data "flexibleengine_elb_flavors" "l4_flavors" {
  type = "L4"
}

# Create Dediacted loadbalancer
resource "flexibleengine_lb_loadbalancer_v3" "loadbalancer" {
  name              = var.loadbalancer_name
  description       = var.description == "" ? "${var.loadbalancer_name} dedicated load balancer" : var.description
  cross_vpc_backend = var.cross_vpc_backend

  vpc_id         = var.vpc_id
  ipv4_subnet_id = var.subnet_id

  l7_flavor_id = data.flexibleengine_elb_flavors.l7_flavors.ids[0]
  l4_flavor_id = data.flexibleengine_elb_flavors.l4_flavors.ids[0]

  #ipv4_eip_id = flexibleengine_vpc_eip.example_eip.id

  #iptype                = "5_bgp"
  #bandwidth_charge_mode = "traffic"
  #sharetype             = "PER"
  #bandwidth_size        = 10

  availability_zone = var.availability_zones
  tags              = var.tags
}

// Create server certificate
resource "flexibleengine_elb_certificate" "cert" {
  count = var.cert && var.certId == null ? 1 : 0

  name        = var.cert_name
  domain      = var.domain
  private_key = var.private_key
  certificate = var.certificate
}

// Create Ip address Groups
resource "flexibleengine_elb_ipgroup" "ipgroup" {
  count = length(var.ipgroups)

  name        = element(var.ipgroups.*.name, count.index)
  description = element(var.ipgroups.*.description, count.index) == "" ? null : element(var.ipgroups.*.description, count.index)

  dynamic "ip_list" {
    for_each = var.ipgroups[count.index].ips

    content {
      ip          = ip_list.value.ip
      description = ip_list.value.description == null ? null : ip_list.value.description
    }
  }
}

# Create listeners
resource "flexibleengine_lb_listener_v3" "listeners" {
  count = length(var.listeners)

  name            = "${var.loadbalancer_name}-${element(var.listeners.*.name, count.index)}"
  description     = element(var.listeners.*.description, count.index) == "" ? null : element(var.listeners.*.description, count.index)
  protocol        = element(var.listeners.*.protocol, count.index)
  protocol_port   = element(var.listeners.*.port, count.index)
  loadbalancer_id = flexibleengine_lb_loadbalancer_v3.loadbalancer.id

  http2_enable       = var.listeners[count.index].http2_enable == null ? null : element(var.listeners.*.protocol, count.index) == "HTTPS" ? var.listeners.*.http2_enable[count.index] : null
  idle_timeout       = var.listeners[count.index].idle_timeout == null ? null : element(var.listeners.*.idle_timeout, count.index)
  request_timeout    = var.listeners[count.index].request_timeout == null ? null : element(var.listeners.*.protocol, count.index) == "HTTP" || element(var.listeners.*.protocol, count.index) == "HTTPS" ? coalesce(element(var.listeners.*.request_timeout, count.index), 60) : null
  response_timeout   = var.listeners[count.index].response_timeout == null ? null : element(var.listeners.*.protocol, count.index) == "HTTP" || element(var.listeners.*.protocol, count.index) == "HTTPS" ? coalesce(element(var.listeners.*.response_timeout, count.index), 60) : null
  tls_ciphers_policy = var.listeners[count.index].tls_ciphers_policy == null ? null : element(var.listeners.*.protocol, count.index) == "HTTPS" ? element(var.listeners.*.tls_ciphers_policy, count.index) : null

  forward_eip = var.listeners[count.index].forward_eip == null ? null : element(var.listeners.*.protocol, count.index) == "HTTP" || var.listeners[count.index].forward_eip == "HTTPS" ? var.listeners[count.index].forward_eip : null

  access_policy = var.listeners[count.index].access_policy == null ? null : element(var.listeners.*.access_policy, count.index)
  ip_group      = var.listeners[count.index].access_policy != null ? var.listeners[count.index].ipgroup_index != null ? var.listeners[count.index].ipgroup_index : flexibleengine_elb_ipgroup.ipgroup[element([for i, group in var.ipgroups : i if group.listener_index == count.index], 0)].id : null

  server_certificate = var.cert && element(var.listeners.*.hasCert, count.index) && var.certId == null ? element(flexibleengine_elb_certificate.cert.*.id, 0) : var.cert && element(var.listeners.*.hasCert, count.index) && var.certId != null ? var.certId : null
  ca_certificate     = var.listeners[count.index].ca_certificate == null ? null : element(var.listeners.*.protocol, count.index) == "HTTPS" ? element(var.listeners.*.ca_certificate, count.index) : null
  sni_certificate    = var.listeners[count.index].sni_certificate == null ? null : element(var.listeners.*.protocol, count.index) == "HTTPS" ? element(var.listeners.*.sni_certificate, count.index) : null

  advanced_forwarding_enabled = var.listeners[count.index].advanced_forwarding_enabled == null ? null : element(var.listeners.*.advanced_forwarding_enabled, count.index)

  tags = var.tags
}

# Create Backend Server Group
resource "flexibleengine_lb_pool_v3" "pools" {
  count = length(var.pools)

  name      = element(var.pools.*.name, count.index)
  protocol  = element(var.pools.*.protocol, count.index)
  lb_method = element(var.pools.*.lb_method, count.index)

  listener_id     = var.pools[count.index].listener_index != null ? flexibleengine_lb_listener_v3.listeners[lookup(var.pools[count.index], "listener_index", count.index)].id : null
  loadbalancer_id = var.pools[count.index].listener_index == null ? flexibleengine_lb_loadbalancer_v3.loadbalancer.id : null

  description = element(var.pools.*.description, count.index) == null ? null : element(var.pools.*.description, count.index)

  /*
  persistence = [{
    type        = element(var.pools.*.type, count.index) == null ? null : element(var.pools.*.type, count.index)
    cookie_name = element(var.pools.*.cookie_name, count.index) == null ? null : element(var.pools.*.cookie_name, count.index)
    timeout     = element(var.pools.*.cookie_name, count.index) == "APP_COOKIE" ? null : element(var.pools.*.timeout, count.index) == null ? null : element(var.pools.*.timeout, count.index)
  }]
  */

}

// Create load balancer member
resource "flexibleengine_lb_member_v3" "members" {
  count = length(var.backends)

  name          = "${flexibleengine_lb_pool_v3.pools[lookup(var.backends[count.index], "pool_index", count.index)].name}-${element(var.backends.*.name, count.index)}"
  address       = var.backends_addresses[var.backends[count.index].address_index]
  protocol_port = var.backends[count.index].port
  pool_id       = flexibleengine_lb_pool_v3.pools[lookup(var.backends[count.index], "pool_index", count.index)].id
  subnet_id     = var.backends[count.index].subnet_id

  weight = element(var.backends.*.weight, count.index) == null ? null : element(var.backends.*.weight, count.index)

  depends_on = [flexibleengine_lb_pool_v3.pools]
}

// Create load balancer monitor
resource "flexibleengine_lb_monitor_v3" "monitors" {
  count = length(var.monitors)

  pool_id     = flexibleengine_lb_pool_v3.pools[lookup(var.monitors[count.index], "pool_index", count.index)].id
  interval    = var.monitors[count.index].interval
  timeout     = var.monitors[count.index].timeout
  max_retries = var.monitors[count.index].max_retries
  protocol    = var.monitors[count.index].protocol

  port     = var.monitors[count.index].port == null ? null : element(var.monitors.*.port, count.index)
  url_path = var.monitors[count.index].url_path == null ? null : var.monitors[count.index].protocol == "HTTP" || var.monitors[count.index].protocol == "HTTPS" ? element(var.monitors.*.url_path, count.index) : null

  depends_on = [flexibleengine_lb_pool_v3.pools, flexibleengine_lb_member_v3.members]
}
