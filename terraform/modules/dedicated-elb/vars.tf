// Load balancer vars
variable "loadbalancer_name" {
  description = "Name of the Load Balancer (It is already prefixed by elb-*)"
  type        = string
}

variable "description" {
  description = "The description for the loadbalancer"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID on which to create the loadbalancer"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to attach the VIP"
  type        = string
}

variable "cross_vpc_backend" {
  description = "Associate the IP addresses of backend servers with load balancer"
  type        = bool
}

variable "loadbalancer_provider" {
  description = "The name of the provider. Currently, only vlb is supported"
  type        = string
  default     = ""
}

variable "security_group_ids" {
  description = "A list of security group IDs to apply to the loadbalancer"
  type        = list(string)
  default     = []
}

variable "availability_zones" {
  description = "A list of security group IDs to apply to the loadbalancer"
  type        = list(string)
  default = [
    "eu-west-0a",
    "eu-west-0b"
  ]
}

variable "tags" {
  description = "The key/value pairs to associate with the loadbalancer"
  type        = map(string)
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
  type        = string
  default     = ""
}

variable "certId" {
  description = "the certificate ID"
  type        = string
  default     = null
}

variable "private_key" {
  description = "the private key in string format"
  type        = string
  default     = ""
}

variable "certificate" {
  description = "the certifiacate in string format"
  type        = string
  default     = ""
}

variable "domain" {
  description = "Domain name"
  type        = string
  default     = ""
}


// ipgroups vars
variable "ipgroups" {
  description = "Ip Address Group list"
  type = list(object({
    name           = string
    description    = optional(string)
    listener_index = number

    ips = list(object({
      ip          = string
      description = optional(string)
    }))
  }))
}

// listeners vars
variable "listeners" {
  description = "Listeners list"
  type = list(object({
    name        = string
    port        = number
    protocol    = string #Protocol used TCP, UDP, HTTP or TERMINATED_HTTPS
    hasCert     = bool
    description = string

    http2_enable       = optional(bool)
    idle_timeout       = optional(number)
    request_timeout    = optional(number)
    response_timeout   = optional(number)
    tls_ciphers_policy = optional(string)

    forward_eip   = optional(bool)
    access_policy = optional(string)

    ipgroup_index = optional(number)

    server_certificate = optional(string)
    ca_certificate     = optional(string)
    sni_certificate    = optional(list(string))

    advanced_forwarding_enabled = optional(bool)

    tags = optional(map(string))
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

    description = optional(string)

    //type        = optional(string)
    //cookie_name = optional(string)
    // timeout parameter invalid if type is APP_COOKIE
    //timeout     = optional(number)
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

    weight = optional(number)
  }))
}

variable "backends_addresses" {
  description = "List of backends adresses"
  type        = list(any)
}

// monitors vars
variable "monitors" {
  description = "List of monitors"
  type = list(object({
    pool_index  = number
    protocol    = string
    interval    = number
    timeout     = number
    max_retries = number

    port = optional(number)

    // required only when protocol is set to HTTP or HTTPS.
    url_path = optional(string)
  }))
  default = []
}
