# ============
# ECS Services
# ============

# ECS Services based on above task definitions
resource "aws_ecs_service" "this" {
  name                              = "${var.name}-sv-${var.environment}"
  cluster                           = var.ecs_cluster_id
  task_definition                   = var.ecs_task_definition_arn
  desired_count                     = var.desired_count
  health_check_grace_period_seconds = try(var.health_check_grace_period_seconds, 100)

  launch_type = var.capacity_provider_name != null ? "EC2" : "FARGATE"
  
  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.this.id]
    assign_public_ip = var.assign_public_ip
  }

  # Capacity provider strategy if provided, else FARGATE
  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider_name != null ? [var.capacity_provider_name] : []
    content {
      capacity_provider = capacity_provider_strategy.value
      weight            = 1
      base              = 1
    }
  }

  dynamic "deployment_controller" {
    for_each = var.enable_code_deploy == true ? [1] : []
    content {
      type = "CODE_DEPLOY"
    }
  }

  load_balancer {
    container_name   = var.load_balancer_config.container_name
    target_group_arn = var.load_balancer_config.blue_target_group_arn
    container_port   = var.load_balancer_config.container_port
  }

  # Placement only for EC2
  dynamic "ordered_placement_strategy" {
    for_each = var.capacity_provider_name != null ? [1] : []
    content {
      type  = "spread"
      field = "instanceId"
    }
  }

  tags = {
    Name = "${var.name}-sv-${var.environment}"
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${var.name}-${var.environment}"
  retention_in_days = 7
}

# ==========================
# Auto Scaling (ECS Service)
# ==========================

# Register ECS Service as scalable
resource "aws_appautoscaling_target" "ecs_service" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# CPU-based auto-scaling policy
resource "aws_appautoscaling_policy" "cpu_scaling" {
  name               = "${aws_ecs_service.this.name}-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_service.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.cpu_target_value
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

# Memory-based auto-scaling policy
resource "aws_appautoscaling_policy" "memory_scaling" {
  name               = "${aws_ecs_service.this.name}-memory-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_service.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.memory_target_value
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

# ============================
# Security Group (ECS Service)
# ============================

resource "aws_security_group" "this" {
  name        = "${var.name}-sv-sg-${var.environment}"
  description = "tasks Security group"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.load_balancer_config != null ? [1] : []
    content {
      description     = "Allow LoadBalancer traffic"
      from_port       = var.load_balancer_config.container_port
      to_port         = var.load_balancer_config.container_port
      protocol        = "tcp"
      security_groups = [var.load_balancer_config.sg_id]
    }
  }

  ingress {
    description = "Jenkins agent inbound access"
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sv-sg-${var.environment}"
  }
}
