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

# =========================
# Auto Scaling Groups (ASG)
# =========================

variable "auto_scaling_groups" {
  description = "Map of ASGs with their configs (optional)"
  type = map(object({
    name = string
    arn = string
    target_capacity = optional(number, 80)
  }))
  default = {}
}
