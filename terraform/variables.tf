variable "AWS_SWARM_INSTANCE_TYPE" {
  type        = string
  description = "Instance type of docker swarm instance"
}

variable "AWS_MANAGER_COUNT" {
  type = number
  validation {
    condition     = var.AWS_MANAGER_COUNT > 0
    error_message = "Swarm must have at least one manager."
  }
  description = "Number of docker swarm managers, must be greater than 0"
}

variable "AWS_MIN_WORKER_COUNT" {
  type = number
  validation {
    condition     = var.AWS_MIN_WORKER_COUNT >= 0 && var.AWS_MIN_WORKER_COUNT <= 5
    error_message = "Min worker count must be in range 0-5."
  }
  description = "Minimum number of docker swarm workers in autoscaling group, must be in range 0-5"
}

variable "AWS_MAX_WORKER_COUNT" {
  type = number
  validation {
    condition     = var.AWS_MAX_WORKER_COUNT >= 0 && var.AWS_MAX_WORKER_COUNT <= 10
    error_message = "Max worker count must be in range 0-10 and greater or equals min worker count."
  }
  description = "Maximum number of docker swarm workers in autoscaling group, must be in range 0-10"
}

variable "AWS_AMI_ID_FILE" {
  type        = string
  default     = "packer/packer-ami.txt"
  description = "Path to file with AMI ID of packer image with docker"
}

variable "DEFAULT_AMI_ID" {
  type        = string
  description = "default AMI ID for packer"
}

variable "WORKER_TOKEN_FILE" {
  type        = string
  default     = "worker-token.txt"
  description = "Path to worker token file"
}

variable "MANAGER_TOKEN_FILE" {
  type        = string
  default     = "manager-token.txt"
  description = "Path to manager token file"
}

variable "AWS_SWARM_SSH_PRIVATE_KEY_PATH" {
  type        = string
  default     = "ssh/swarmkey"
  description = "Path to SSH private key"
}

variable "AWS_SWARM_SSH_PUBLIC_KEY_PATH" {
  type        = string
  default     = "ssh/swarmkey.pub"
  description = "Path to SSH public key"
}

variable "AWS_INSTANCE_USERNAME" {
  type        = string
  default     = "ubuntu"
  description = "SSH username"
}

variable "AWS_SWARM_DOMAIN" {
  type        = string
  description = "Docker swarm domain in AWS Route 53"
}

variable "AWS_DEFAULT_AZ" {
  type        = string
  description = "Default AWS availability zone"
}


variable "AWS_SHARED_VOLUME_MOUNTPOINT" {
  type        = string
  default     = "/mnt/shared_data"
  description = "Shared volume mountpoint of docker swarm nodes"
}

variable "BASTION_IP_FILE" {
  type        = string
  default     = "ip-files/ip-bastion.txt"
  description = "Output file for bastion IP"
}

variable "SWARM_LEADER_IP_FILE" {
  type        = string
  default     = "ip-files/ip-swarm-leader.txt"
  description = "Output file for swarm leader IP"
}

variable "LOW_CPU_THRESH" {
  type        = string
  default     = "20"
  description = "Low CPU thresh for worker autoscaling"
}

variable "HIGH_CPU_THRESH" {
  type        = string
  default     = "80"
  description = "High CPU thresh for worker autoscaling"
}

variable "AUTH_PASSWORD" {
  type        = string
  description = "Auth password"
}

variable "AUTH_USERNAME" {
  type        = string
  description = "Auth username"
}

variable "CREATE_HOSTED_ZONE" {
  type        = bool
  default     = false
  description = "Flag if create hosted zone"
}

variable "CONNECTION_TIMEOUT" {
  type        = string
  default     = "30s"
  description = "Connection timeout for provisioner"
}
