# ==========================
# Core ECS Service Variables
# ==========================

variable "project_name" {
  description = "The name of the project. Used consistently for naming, tagging, and organizational purposes across resources."
  type        = string
}

variable "name" {
  description = "Base name identifier for ECS service resources (used for consistent naming and tagging)."
  type        = string
}

variable "environment" {
  description = "Deployment environment identifier (e.g., dev, staging, prod)."
  type        = string
}

variable "ecs_cluster_id" {
  description = "ID of the ECS cluster where the service will be deployed."
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster (used for autoscaling target reference)."
  type        = string
}

variable "ecs_task_definition_arn" {
  description = "ARN of the ECS task definition to run in this service."
  type        = string
}

variable "desired_count" {
  description = "Number of ECS tasks to run for the service."
  type        = number
}

variable "health_check_grace_period_seconds" {
  description = "Time in seconds to ignore health checks after task start (default: 100)."
  type        = number
  default     = 100
}


# ==========================
# Networking Configuration
# ==========================

variable "vpc_id" {
  description = "VPC ID where the ECS service and security group will be created."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ECS tasks' network interfaces."
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Whether to assign a public IP to ECS tasks (default: false)."
  type        = bool
  default     = false
}


# ==========================
# Capacity Provider & Deployment
# ==========================

variable "capacity_provider_name" {
  description = "Name of the capacity provider (e.g., FARGATE, FARGATE_SPOT). Defaults to FARGATE if not provided."
  type        = string
  default     = null
}

variable "enable_code_deploy" {
  description = "If true, uses CODE_DEPLOY deployment controller for blue/green deployments."
  type        = bool
  default     = false
}


# ===========================
# Load Balancer Configuration
# ===========================

variable "load_balancer_config" {
  description = "Load balancer configuration for ECS service."
  type = object({
    container_name        = string
    blue_target_group_arn = string
    container_port        = number
    sg_id                 = string
  })
  default = null
}

# ==========================
# Auto Scaling Configuration
# ==========================

variable "min_capacity" {
  description = "Minimum number of ECS tasks for auto-scaling."
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of ECS tasks for auto-scaling."
  type        = number
  default     = 10
}

variable "cpu_target_value" {
  description = "Target average CPU utilization percentage for ECS service auto-scaling."
  type        = number
  default     = 90
}

variable "memory_target_value" {
  description = "Target average Memory utilization percentage for ECS service auto-scaling."
  type        = number
  default     = 90
}
