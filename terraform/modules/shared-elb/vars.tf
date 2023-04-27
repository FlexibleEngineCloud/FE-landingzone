// Load balancer vars
variable "loadbalancer_name" {
  description = "Name of the Load Balancer (It is already prefixed by elb-*)"
  type        = string
}

variable "description" {
  description = "The description for the loadbalancer"
  type        = string
  default = ""
}

variable "subnet_id" {
  description = "Subnet ID to attach the VIP"
  type        = string
}

variable "vip_address" {
  description = "Address of the VIP (In the same Subnet)"
  type        = string
  default = ""
}

variable "loadbalancer_provider" {
  description = "The name of the provider. Currently, only vlb is supported"
  type        = string
  default = ""
}

variable "security_group_ids" {
  description = "A list of security group IDs to apply to the loadbalancer"
  type        = list(string)
  default = []
}

variable "admin_state_up" {
  description = "The administrative state of the loadbalancer. A valid value is true (UP) or false (DOWN)"
  type        = bool
  default = true
}

variable "tags" {
  description = "The key/value pairs to associate with the loadbalancer"
  type = map(string)
  default = {
    Environment = "landing-zone"
  }
}

// certificate vars
variable "cert" {
  description = "Boolean to know if we add certificate"
  type        = bool
  default     = false
}

variable "cert_name" {
  description = "the certifiacet name"
  type = string
  default = ""
}

variable "certId" {
  description = "the certificate ID"
  type = string
  default = null
}

variable "private_key" {
  description = "the private key in string format"
  type = string
  default = ""
}

variable "certificate" {
  description = "the certifiacate in string format"
  type = string
  default = ""
}

variable "domain" {
  description = "Domain name"
  type = string
  default = ""
}

// listeners vars
variable "listeners" {
  description = "Listeners list"
  type = list(object({
    name     = string
    port     = number
    protocol = string #Protocol used TCP, UDP, HTTP or TERMINATED_HTTPS
    hasCert  = bool
    description  = string
    
    http2_enable = optional(bool)
    transparent_client_ip_enable = optional(bool)
    idle_timeout = optional(number)
    request_timeout = optional(number)
    response_timeout = optional(number)
    tls_ciphers_policy = optional(string)
    
    tags =  optional(map(string))
  }))
}


// pools vars
variable "pools" {
  description = "Pools list"
  type = list(object({
    name           = string
    protocol       = string
    lb_method      = string # Load Balancing method (ROUND_ROBIN recommended)
    listener_index = number # Listenerused in this pool (Can be null)

  }))
}

// members vars
variable "backends" {
  description = "List of backends"
  type = list(object({
    name          = string
    port          = number
    address_index = string
    pool_index    = number
    subnet_id     = string
  }))
}

variable "backends_addresses" {
  description = "List of backends adresses"
  type        = list
}

// monitors vars
variable "monitors" {
  description = "List of monitors"
  type = list(object({
    name        = string
    pool_index  = number
    protocol    = string
    delay       = number
    timeout     = number
    max_retries = number
    //url_path       = string
    //http_method    = string
    //expected_codes = string
  }))
  default = []
}

// whitelists vars
variable "listeners_whitelist" {
  description = "Listeners whitelist"
  type = list(object({
    listeners_index  = number
    enable_whitelist = bool
    whitelist        = string #Comma separated : "192.168.11.1,192.168.0.1/24,192.168.201.18/8"
  }))
  default = []
}

// L7 policies vars
variable "l7policies" {
  description = "List of L7 policies redirected to pools/listeners"
  type = list(object({
    name                    = string
    action                  = string # REDIRECT_TO_POOL / REDIRECT_TO_LISTENER
    description             = string
    position                = number
    listener_index          = number
    redirect_listener_index = number # if REDIRECT_TO_LISTENER is set, or null LISTENER must be listen on HTTPS_TERMINATED
    redirect_pool_index     = number # if REDIRECT_TO_POOL is set, or null - pool used to redirect must be not associated with a listener
  }))
  default = []
}

// L7 rules vars
variable "l7policies_rules" { # Only if REDIRECT_TO_POOL
  description = "List of L7 policies redirected to pools/listeners"
  type = list(object({
    l7policy_index = number
    type           = string
    compare_type   = string
    value          = string
    description = string
    key = string
  }))
  default = []
}