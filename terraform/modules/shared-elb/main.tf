# EIP Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

resource "flexibleengine_lb_loadbalancer_v2" "loadbalancer" {
  name          = var.loadbalancer_name
  description   = var.description == "" ? "${var.loadbalancer_name} shared load balancer" : var.description
  vip_subnet_id = var.subnet_id

  vip_address           = var.vip_address == "" ? null : var.vip_address
  loadbalancer_provider = var.loadbalancer_provider == "" ? null : var.loadbalancer_provider
  security_group_ids    = var.security_group_ids == [] ? null : var.security_group_ids

  admin_state_up = var.admin_state_up // either true UP or false DOWN

  tags = var.tags
}

resource "flexibleengine_elb_certificate" "cert" {
  count = var.cert && var.certId == null ? 1 : 0

  name        = var.cert_name
  domain      = var.domain
  private_key = var.private_key
  certificate = var.certificate
}

resource "flexibleengine_lb_listener_v2" "listeners" {
  count = length(var.listeners)

  name            = "${var.loadbalancer_name}-${element(var.listeners.*.name, count.index)}"
  protocol        = element(var.listeners.*.protocol, count.index)
  protocol_port   = element(var.listeners.*.port, count.index)
  loadbalancer_id = flexibleengine_lb_loadbalancer_v2.loadbalancer.id

  default_tls_container_ref = var.cert && element(var.listeners.*.hasCert, count.index) && var.certId == null ? element(flexibleengine_elb_certificate.cert.*.id, 0) : var.cert && element(var.listeners.*.hasCert, count.index) && var.certId != null ? var.certId : null
  description               = element(var.listeners.*.description, count.index) == "" ? null : element(var.listeners.*.description, count.index)

  http2_enable                 = var.listeners[count.index].http2_enable == null ? null : element(var.listeners.*.http2_enable, count.index) && element(var.listeners.*.protocol, count.index) == "TERMINATED_HTTPS" ? var.listeners.*.http2_enable[count.index] : null
  transparent_client_ip_enable = var.listeners[count.index].transparent_client_ip_enable == null ? null : element(var.listeners.*.protocol, count.index) == "TCP" || element(var.listeners.*.protocol, count.index) == "UDP" ? element(var.listeners.*.transparent_client_ip_enable, count.index) : element(var.listeners.*.protocol, count.index) == "HTTP" || element(var.listeners.*.protocol, count.index) == "TERMINATED_HTTPS" ? true : null
  idle_timeout                 = var.listeners[count.index].idle_timeout == null ? null : element(var.listeners.*.idle_timeout, count.index) == "" ? null : element(var.listeners.*.idle_timeout, count.index)
  request_timeout              = var.listeners[count.index].request_timeout == null ? null : element(var.listeners.*.protocol, count.index) == "HTTP" || element(var.listeners.*.protocol, count.index) == "TERMINATED_HTTPS" ? coalesce(element(var.listeners.*.request_timeout, count.index), 60) : null
  response_timeout             = var.listeners[count.index].response_timeout == null ? null : element(var.listeners.*.protocol, count.index) == "HTTP" || element(var.listeners.*.protocol, count.index) == "TERMINATED_HTTPS" ? coalesce(element(var.listeners.*.response_timeout, count.index), 60) : null
  tls_ciphers_policy           = var.listeners[count.index].tls_ciphers_policy == null ? null : element(var.listeners.*.protocol, count.index) == "TERMINATED_HTTPS" ? coalesce(element(var.listeners.*.tls_ciphers_policy, count.index), "tls-1-0") : null

  tags = element(var.listeners.*.tags, count.index) == {} ? null : element(var.listeners.*.tags, count.index)

  //depends_on = [flexibleengine_elb_certificate.cert]
}

resource "flexibleengine_lb_pool_v2" "pools" {
  count = length(var.pools)

  name      = element(var.pools.*.name, count.index)
  protocol  = element(var.pools.*.protocol, count.index)
  lb_method = element(var.pools.*.lb_method, count.index)

  listener_id     = var.pools[count.index].listener_index != null ? flexibleengine_lb_listener_v2.listeners[lookup(var.pools[count.index], "listener_index", count.index)].id : null
  loadbalancer_id = var.pools[count.index].listener_index == null ? flexibleengine_lb_loadbalancer_v2.loadbalancer.id : null

  description    = element(var.pools.*.description, count.index) == null ? null : element(var.pools.*.description, count.index)
  admin_state_up = element(var.pools.*.admin_state_up, count.index) == null ? null : element(var.pools.*.admin_state_up, count.index)

  /*
  persistence = [{
    type        = element(var.pools.*.type, count.index) == null ? null : element(var.pools.*.type, count.index)
    cookie_name = element(var.pools.*.cookie_name, count.index) == null ? null : element(var.pools.*.cookie_name, count.index)
    timeout     = element(var.pools.*.cookie_name, count.index) == "APP_COOKIE" ? null : element(var.pools.*.timeout, count.index) == null ? null : element(var.pools.*.timeout, count.index)
  }]
  */
}

resource "flexibleengine_lb_member_v2" "members" {
  count = length(var.backends)

  name          = "${flexibleengine_lb_pool_v2.pools[lookup(var.backends[count.index], "pool_index", count.index)].name}-${element(var.backends.*.name, count.index)}"
  address       = var.backends_addresses[var.backends[count.index].address_index]
  protocol_port = var.backends[count.index].port
  pool_id       = flexibleengine_lb_pool_v2.pools[lookup(var.backends[count.index], "pool_index", count.index)].id
  subnet_id     = var.backends[count.index].subnet_id

  weight         = element(var.backends.*.weight, count.index) == null ? null : element(var.backends.*.weight, count.index)
  admin_state_up = element(var.backends.*.admin_state_up, count.index) == null ? null : element(var.backends.*.admin_state_up, count.index)

  depends_on = [flexibleengine_lb_pool_v2.pools]
}

resource "flexibleengine_lb_monitor_v2" "monitor" {
  count = length(var.monitors)

  name        = "${flexibleengine_lb_pool_v2.pools[lookup(var.monitors[count.index], "pool_index", count.index)].name}-${element(var.monitors.*.name, count.index)}"
  pool_id     = flexibleengine_lb_pool_v2.pools[lookup(var.monitors[count.index], "pool_index", count.index)].id
  type        = var.monitors[count.index].protocol
  delay       = var.monitors[count.index].delay
  timeout     = var.monitors[count.index].timeout
  max_retries = var.monitors[count.index].max_retries

  url_path       = var.monitors[count.index].url_path == null ? null : var.monitors[count.index].protocol == "HTTP" || var.monitors[count.index].protocol == "HTTPS" ? element(var.monitors.*.url_path, count.index) : null
  http_method    = var.monitors[count.index].http_method == null ? null : var.monitors[count.index].protocol == "HTTP" || var.monitors[count.index].protocol == "HTTPS" ? element(var.monitors.*.http_method, count.index) : null
  expected_codes = var.monitors[count.index].expected_codes == null ? null : var.monitors[count.index].protocol == "HTTP" || var.monitors[count.index].protocol == "HTTPS" ? element(var.monitors.*.expected_codes, count.index) : null

  admin_state_up = var.monitors[count.index].admin_state_up == "" ? null : var.monitors[count.index].admin_state_up

  depends_on = [flexibleengine_lb_pool_v2.pools, flexibleengine_lb_member_v2.members]
}


resource "flexibleengine_lb_whitelist_v2" "whitelists" {
  count = length(var.listeners_whitelist)

  listener_id = flexibleengine_lb_listener_v2.listeners[lookup(var.listeners_whitelist[count.index], "listener_index", count.index)].id

  enable_whitelist = var.listeners_whitelist[count.index].enable_whitelist == null ? false : true
  whitelist        = var.listeners_whitelist[count.index].whitelist == null ? null : element(var.listeners_whitelist[count.index].whitelist, count.index)
}

resource "flexibleengine_lb_l7policy_v2" "l7policies" {
  count = length(var.l7policies)

  name        = var.l7policies[count.index].name
  action      = var.l7policies[count.index].action
  listener_id = flexibleengine_lb_listener_v2.listeners[lookup(var.l7policies[count.index], "listener_index", count.index)].id

  redirect_listener_id = var.l7policies[count.index].redirect_listener_index != null ? flexibleengine_lb_listener_v2.listeners[lookup(var.l7policies[count.index], "redirect_listener_index", count.index)].id : null
  redirect_pool_id     = var.l7policies[count.index].redirect_pool_index != null ? flexibleengine_lb_pool_v2.pools[lookup(var.l7policies[count.index], "redirect_pool_index", count.index)].id : null

  description    = var.l7policies[count.index].description == null ? null : element(var.l7policies.*.description, count.index)
  position       = var.l7policies[count.index].position == null ? null : var.l7policies[count.index].position
  admin_state_up = var.l7policies[count.index].admin_state_up == null ? null : var.l7policies[count.index].admin_state_up
}

resource "flexibleengine_lb_l7rule_v2" "l7rules" {
  count = length(var.l7policies_rules)

  l7policy_id  = flexibleengine_lb_l7policy_v2.l7policies[lookup(var.l7policies_rules[count.index], "l7policy_index", count.index)].id
  type         = var.l7policies_rules[count.index].type
  compare_type = var.l7policies_rules[count.index].compare_type
  value        = var.l7policies_rules[count.index].value

  key = var.l7policies_rules[count.index].key == null ? null : element(var.l7policies_rules.*.key, count.index)

  admin_state_up = var.l7policies_rules[count.index].admin_state_up == null ? null : var.l7policies_rules[count.index].admin_state_up
}
