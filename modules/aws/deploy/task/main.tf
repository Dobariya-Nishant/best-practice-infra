# ==========================
# ECS Task Definition
# ==========================

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.name}-task-${var.environment}"
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  # ==========================
  # Container Definitions
  # ==========================
  container_definitions = jsonencode([
    for container in var.containers : {
      name        = container.name
      image       = container.image
      essential   = try(container.essential, true)
      cpu         = try(container.cpu, null)
      memory      = try(container.memory, null)
      memoryReservation = try(container.memory_reservation, null)
      command     = try(container.command, null)
      entryPoint  = try(container.entry_point, null)
      workingDirectory = try(container.working_directory, null)
      portMappings = try(container.port_mappings, [])
      environment  = try([
        for env in lookup(container, "environment", []) : {
          name  = env.name
          value = env.value
        }
      ], [])
      secrets = try([
        for s in lookup(container, "secrets", []) : {
          name      = s.name
          valueFrom = s.value_from
        }
      ], [])

      # Logging
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = container.name
        }
      }

      # Mount volumes if defined
      mountPoints = try(container.mount_points, [])
      volumesFrom = try(container.volumes_from, [])
    }
  ])

  # ==========================
  # Volume Configuration
  # ==========================
  dynamic "volume" {
    for_each = var.volumes
    content {
      name = volume.value.name

      dynamic "host_path" {
        for_each = lookup(volume.value, "host_path", null) != null ? [1] : []
        content {
          path = volume.value.host_path
        }
      }

      dynamic "efs_volume_configuration" {
        for_each = lookup(volume.value, "efs_volume_configuration", null) != null ? [1] : []
        content {
          file_system_id          = volume.value.efs_volume_configuration.file_system_id
          root_directory          = try(volume.value.efs_volume_configuration.root_directory, "/")
          transit_encryption      = try(volume.value.efs_volume_configuration.transit_encryption, "ENABLED")
          authorization_config {
            access_point_id = try(volume.value.efs_volume_configuration.access_point_id, null)
            iam             = try(volume.value.efs_volume_configuration.iam, "ENABLED")
          }
        }
      }
    }
  }

  tags = {
      Name = "${var.name}-task-${var.environment}"
    }
}
