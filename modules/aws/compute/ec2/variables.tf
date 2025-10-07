# ==========================
# Core Project Configuration
# ==========================

variable "project_name" {
  description = "Name of the overall project. Used for consistent naming and tagging across all resources."
  type        = string
}

variable "name" {
  description = "Base name used as an identifier for all resources (e.g., key name, launch template name, etc.)."
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod). Used for tagging and naming consistency."
  type        = string
}

# ==========
# Networking
# ==========

variable "vpc_id" {
  description = "The VPC ID where resources like EC2, security groups, etc. will be deployed."
  type        = string
}

variable "subnet_id" {
  description = "List of subnet IDs for the Auto Scaling Group to launch instances in. Determines availability zones."
  type        = string
}

# ====================
# Security Group Rules
# ====================

variable "enable_public_ssh" {
  description = "Allow inbound SSH access (port 22) from any IP (0.0.0.0/0). Use with caution in production."
  type        = bool
  default     = false
}

variable "enable_ssh_from_current_ip" {
  description = "Allow SSH access (port 22) only from your current public IP."
  type        = bool
  default     = false
}

# =======================
# EC2 & AMI Configuration
# =======================

variable "instance_type" {
  description = "EC2 instance type to launch (e.g., t3.micro, m5.large)."
  type        = string
  default     = "t2.micro"
}

variable "ebs_type" {
  description = "EBS volume type (e.g., gp2, gp3, io1) attached to EC2 instances."
  type        = string
  default     = "gp2"
}

variable "ebs_size" {
  description = "Size (in GB) of the root EBS volume attached to EC2 instances."
  type        = string
  default     = 30
}

variable "use_spot" {
  description = "Use EC2 Spot Instances for cost optimization. Set to true to enable."
  type        = bool
  default     = false
}

variable "associate_public_ip_address" {
  description = "Associate a public IP address with launched EC2 instances. Useful for SSH or internet access."
  type        = bool
  default     = false
}

variable "user_data" {
  description = "Base64-encoded user data script to bootstrap EC2 instances (e.g., install packages, join ECS cluster)."
  type        = string
  default     = ""
}

# ================================
# CloudWatch Alarms (Auto Scaling)
# ================================

variable "enable_auto_scaling_alarms" {
  description = "Enable CloudWatch alarms that trigger auto scaling based on CPU utilization."
  type        = bool
  default     = false
}