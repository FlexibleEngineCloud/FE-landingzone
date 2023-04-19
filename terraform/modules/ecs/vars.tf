variable "instance_name" {
  description = "Name of the ECS instance and the associated volume"
  type        = string
}

variable "instance_count" {
  description = "Number of instances to launch"
  default     = 1
  type        = number
}

variable "flavor_name" {
  description = "The flavor type of instance to start"
  type        = string
}

variable "network_uuids" {
  description = "The subnet ID to launch in"
  type        = list(string)
}

variable "security_groups" {
  description = "A list of security group names to associate with"
  type        = list(string)
  default = [ "default" ]
}

variable "key_name" {
  description = "The key pair name"
  type        = string
}

variable "image_id" {
  description = "The IMS image ID of the instance"
  type        = string
}


variable "availability_zones" {
  description = "The availability zones list to be mapped to each instance if count>1"
  type        = list(string)
  default = [ "eu-west-0a" ]
}

variable "metadata" {
  description = "A mapping of metadata to assign to the resource"
  default     = {}
  type        = map(string)
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  default     = {}
  type        = map(string)
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  default     = ""
  type        = string
}