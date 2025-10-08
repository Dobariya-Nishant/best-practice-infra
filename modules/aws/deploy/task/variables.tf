# ==========================
# Core Config
# ==========================

variable "project_name" {
  description = "The name of the project. Used consistently for naming, tagging, and organizational purposes across resources."
  type        = string
}

variable "name" {
  description = "Base name for ECS Task Definition family."
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)."
  type        = string
}

variable "aws_region" {
  description = "AWS region for ECS task logging."
  type        = string
}

variable "cpu" {
  description = "Total CPU units for the task definition."
  type        = number
  default     = 512
}

variable "memory" {
  description = "Total memory (MiB) for the task definition."
  type        = number
  default     = 1024
}

variable "network_mode" {
  description = "Networking mode for ECS tasks. (awsvpc | bridge | host | none)"
  type        = string
  default     = "awsvpc"
}

variable "requires_compatibilities" {
  description = "Launch types supported by the task (FARGATE or EC2)."
  type        = list(string)
  default     = ["FARGATE"]
}


variable "task_role_arn" {
  description = "IAM role ARN for ECS task runtime permissions (S3, DynamoDB, etc.)."
  type        = string
  default = null
}

variable "log_group_name" {
  description = "CloudWatch Log Group name used for ECS container logs."
  type        = string
}


# ==========================
# Container Definitions
# ==========================

variable "containers" {
  description = <<EOT
List of container configurations for the task.
Each container object supports:
[
  {
    name               = "app"
    image              = "nginx:latest"
    cpu                = 256
    memory             = 512
    essential          = true
    port_mappings = [
      {
        containerPort = 80
        hostPort      = 80
        protocol      = "tcp"
      }
    ]
    environment = [
      {
        name  = "APP_ENV"
        value = "production"
      },
      {
        name  = "API_URL"
        value = "https://api.example.com"
      }
    ]
    secrets = [
      {
        name       = "DB_PASSWORD"
        value_from = "arn:aws:ssm:us-east-1:123456789012:parameter/db-password"
      }
    ]
    mount_points = [
      {
        sourceVolume  = "app-data"
        containerPath = "/usr/share/nginx/html"
      }
    ]
  },
  {
    name      = "sidecar"
    image     = "busybox"
    essential = false
    command   = ["sh", "-c", "while true; do echo Sidecar running; sleep 30; done"]
    environment = [
      {
        name  = "LOG_LEVEL"
        value = "debug"
      }
    ]
  }
]
EOT

  type = list(object({
    name               = string
    image              = string
    cpu                = optional(number)
    memory             = optional(number)
    memory_reservation = optional(number)
    essential          = optional(bool)
    entry_point        = optional(list(string))
    command            = optional(list(string))
    working_directory  = optional(string)
    port_mappings = optional(list(object({
      containerPort = number
      hostPort      = optional(number)
      protocol      = optional(string)
    })))
    environment = optional(list(object({
      name  = string
      value = string
    })))
    secrets = optional(list(object({
      name       = string
      value_from = string
    })))
    mount_points = optional(list(object({
      sourceVolume  = string
      containerPath = string
      readOnly      = optional(bool)
    })))
    volumes_from = optional(list(object({
      sourceContainer = string
      readOnly        = optional(bool)
    })))
  }))
}


# ==========================
# Volume Configuration
# ==========================

variable "volumes" {
  description = <<EOT
List of volumes to attach to the ECS Task.
Supports host_path or EFS configurations.
Example:
[
  {
    name      = "app-data"
    host_path = "/mnt/data"
  },
  {
    name = "efs-volume"
    efs_volume_configuration = {
      file_system_id   = "fs-xxxxxx"
      root_directory   = "/data"
      access_point_id  = "fsap-xxxxxx"
      iam              = "ENABLED"
    }
  }
]
EOT
  type = list(object({
    name                  = string
    host_path             = optional(string)
    efs_volume_configuration = optional(object({
      file_system_id   = string
      root_directory   = optional(string)
      access_point_id  = optional(string)
      iam              = optional(string)
      transit_encryption = optional(string)
    }))
  }))
  default = []
}