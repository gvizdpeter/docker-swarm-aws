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
  type        = map(any)
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

variable "connection_object" {
  type = object({
    user         = string
    private_key  = string
    host         = string
    bastion_host = string
    bastion_user = string
    timeout      = string
  })
}