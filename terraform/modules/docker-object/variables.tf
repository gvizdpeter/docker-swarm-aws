variable "connection_user" {
  type        = string
  description = "Connection user"
}

variable "connection_private_key" {
  type        = string
  description = "Connection private key"
}

variable "connection_host" {
  type        = string
  description = "Connection host"
}

variable "connection_bastion_host" {
  type        = string
  description = "Connection bastion host"
  default     = null
}

variable "connection_bastion_user" {
  type        = string
  description = "Connection bastion user"
  default     = null
}

variable "connection_timeout" {
  type        = string
  description = "Connection timeout"
  default     = "30s"
}

variable "object_definition_file" {
  type        = string
  description = "Docker object definition file"
}

variable "object_name" {
  type        = string
  description = "Docker object name"
}

variable "object_type" {
  type        = string
  description = "Docker object type"

  validation {
    condition     = contains(["stack", "config", "secret"], var.object_type)
    error_message = "Valid values for object_type are (stack, config)."
  }
}

variable "object_defintion_variables" {
  type        = map
  description = "Docker object defintion variables"
  default     = {}
}

variable "remote_object_definition_file" {
  type        = string
  description = "Object definition file on remote host"
  default     = null
}

variable "remote_object_definition_directory" {
  type        = string
  description = "Object definition directory on remote host"
  default     = "/tmp"
}