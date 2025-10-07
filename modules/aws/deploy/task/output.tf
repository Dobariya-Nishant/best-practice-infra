output "task_definition_arn" {
  description = "ARN of the ECS Task Definition."
  value       = aws_ecs_task_definition.this.arn
}

output "task_definition_family" {
  description = "Family name of the ECS Task Definition."
  value       = aws_ecs_task_definition.this.family
}

output "revision" {
  description = "Task definition revision number."
  value       = aws_ecs_task_definition.this.revision
}
