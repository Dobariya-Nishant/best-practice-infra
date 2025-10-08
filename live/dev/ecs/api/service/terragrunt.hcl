include "env" {
  path = find_in_parent_folders("env.hcl")
}

include "api" {
  path = find_in_parent_folders("api.hcl")
}

terraform {
  source = "${get_path_to_repo_root()}/modules/aws/deploy/service"
}

dependency "ecs" {
  config_path = "${dirname(find_in_parent_folders("env.hcl"))}/ecs"

  mock_outputs = {
    id   = "mock-ecs-id"
    name = "mock-ecs-name"
    arn  = "arn:aws:autoscaling:us-east-1:123456789012:autoScalingGroup:uuid:autoScalingGroupName/ecs"
  }
}

dependency "alb" {
  config_path = "${dirname(find_in_parent_folders("env.hcl"))}/alb"

  mock_outputs = {
    id                 = "mock-alb-id"
    sg_id              = "mock-alb-sg-id"
    https_listener_arn = "arn:aws:autoscaling:us-east-1:123456789012:mock:uuid:mock/mock"
    blue_tg = {
      api = {
        name = "mock-tg-name"
        arn  = "arn:aws:autoscaling:us-east-1:123456789012:mock:uuid:mock/mock"
      }
    }
    green_tg = {
      api = {
        name = "mock-tg-name"
        arn  = "arn:aws:autoscaling:us-east-1:123456789012:mock:uuid:mock/mock"
      }
    }
  }
}

dependency "task" {
  config_path = "${dirname(find_in_parent_folders("env.hcl"))}/ecs/api/task"

  mock_outputs = {
    revision   = "1"
    family = "mock-api"
    arn  = "arn:aws:autoscaling:us-east-1:123456789012:autoScalingGroup:uuid:autoScalingGroupName/api"
  }
}

inputs = {
  name = "api"
  desired_count = 1

  ecs_cluster_id = dependency.ecs.outputs.id
  ecs_cluster_name = dependency.ecs.outputs.name
  # capacity_provider_name = dependency.ecs.outputs.asg_cp["api"].arn

  ecs_task_definition_arn  = dependency.task.outputs.arn

  
  enable_code_deploy = true

  load_balancer_config = {
    container_name        = "api"
    blue_target_group_arn = dependency.alb.outputs.blue_tg["api"].arn
    container_port        = 80
    sg_id                 = dependency.alb.outputs.sg_id
  }
}



