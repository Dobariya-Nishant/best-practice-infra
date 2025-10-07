# ==========================
# Core Project Configuration
# ==========================

variable "project_name" {
  description = "The name of the project. Used consistently for naming, tagging, and organizational purposes across resources."
  type        = string
}

variable "name" {
  description = "Base name identifier applied to all resources (e.g., cluster name, IAM roles, etc.) for consistent resource naming."
  type        = string
}

variable "environment" {
  description = "Deployment environment identifier (e.g., dev, staging, prod). Used for environment-specific tagging and naming."
  type        = string
}

# =====================================
# ECS + Deployment Target Configuration
# =====================================

variable "ecs_cluster_name" {
  description = "Deployment environment identifier (e.g., dev, staging, prod). Used for environment-specific tagging and naming."
  type        = string
}

variable "ecs_service_name" {
  description = "Deployment environment identifier (e.g., dev, staging, prod). Used for environment-specific tagging and naming."
  type        = string
}

# ===========================
# Load Balancer Configuration
# ===========================

variable "listener_arn" {
  description = "Deployment environment identifier (e.g., dev, staging, prod). Used for environment-specific tagging and naming."
  type        = string
}

variable "blue_target_group_name" {
  description = "Deployment environment identifier (e.g., dev, staging, prod). Used for environment-specific tagging and naming."
  type        = string
}

variable "green_target_group_name" {
  description = "Deployment environment identifier (e.g., dev, staging, prod). Used for environment-specific tagging and naming."
  type        = string
}


