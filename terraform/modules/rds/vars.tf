variable "db_type" {
  description = "Type of database. Can be MySQL, PostgreSQL, SQLServer"
  default     = ""
}

variable "db_version" {
  description = "Version of database. Check Terraform and FE documentation to get version list"
  default     = ""
}

variable "db_flavor" {
  description = "Flavor of database. Check Terraform and FE documentation to get flavor list"
  default     = ""
}

variable "secgroup_id" {
  description = "Security group ID to use for RDS"
  default     = ""
}

variable "db_tcp_port" {
  description = "TCP port of database"
  default     = ""
}

variable "db_backup_starttime" {
  description = "start time of database backup (Exemple : 08:00-09:00)"
  default     = null
  type        = string
}

variable "db_backup_keepdays" {
  description = "keep days of database backup"
  default     = null
  type        = number
}

variable "db_root_password" {
  description = "root password of RDS"
  default     = ""
  type        = string
}

variable "rds_ha_enable" {
  description = "To enable HA of RDS"
  default     = false
  type        = bool
}

variable "rds_ha_replicamode" {
  description = "To enable HA of RDS"
  default     = ""
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet"
  default     = ""
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  default     = null
  type        = string
}

variable "rds_instance_name" {
  description = "name of RDS instances"
  default     = ""
  type        = string
}

variable "rds_description" {
  description = "Description of RDS instances"
  default     = ""
  type        = string
}

variable "rds_instance_volume_type" {
  description = "Volume type of instances"
  default     = "COMMON"
  type        = string
}

variable "rds_instance_volume_size" {
  description = "Volume size of instances"
  default     = 0
  type        = number
}

variable "rds_instance_volume_encryption_id" {
  description = "KMS Key id for encryption"
  default     = null
  type        = string
}

variable "rds_instance_az" {
  description = "Availability zones of RDS instance (Multiple AZ must be specified if you are using HA)"
  default     = ["eu-west-0a"]
  type        = list(string)
}

variable "rds_read_replicat_list" {
  type = list(object({
    name               = optional(string)
    flavor             = optional(string)
    availability_zone  = optional(string)

    volume_type        = optional(string)
    disk_encryption_id = optional(string)
  }))
}

variable "rds_parametergroup_values" {
  description = "Map of the values of the parameter group"
  type        = map(string)
  default     = {}
}



variable "fixed_ip" {
  description = "Specifies an intranet IP address of RDS DB instance"
  default     = null
  type        = string
}

variable "time_zone" {
  description = "Specifies the UTC time zone. The value ranges from UTC-12:00 to UTC+12:00 at the full hour"
  default     = null
  type        = string
}

variable "ssl_enable" {
  description = "Specifies whether to enable the SSL for MySQL database"
  default     = null
  type        = bool
}


variable "rds_accounts_list" {
  description = "RDS Accounts list"
  type = list(object({
    name               = optional(string)
    password             = optional(string)
  }))
}

variable "rds_databases_list" {
  description = "RDS Databases list"
  type = list(object({
    name               = optional(string)
    char_set      = optional(string)
  }))
}

variable "rds_privileges_list" {
  description = "RDS Privileges list"
  type = list(object({
    db_name               = optional(string)
    name          = optional(string)
    readonly = optional(string)
  }))
}

variable "tags" {
  type        = map(string)
  description = "Common tag set for project resources"
  default     = {}
}