variable "eips" {
  description = "Public IPs list"
  type = list(object({
    floating_ip_id        = string
    enable_l7        = bool
    traffic_pos_id    = number
    http_request_pos_id     = number
    cleaning_access_pos_id = number
    app_type_id = number
  }))
}