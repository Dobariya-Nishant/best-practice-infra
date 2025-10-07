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

dependency "api_asg" {
  config_path = "${dirname(find_in_parent_folders("env.hcl"))}/ecs/api/asg"

  mock_outputs = {
    id   = "api-asg-id"
    name = "api-asg-name"
    arn  = "arn:aws:autoscaling:us-east-1:123456789012:autoScalingGroup:uuid:autoScalingGroupName/api"
  }
}



inputs = {
  name = "api"

  ecs_cluster_id = dependency.ecs.outputs.id
  ecs_cluster_name = dependency.ecs.outputs.name
  ecs_task_definition_arn 
  desired_count = 1

  capacity_provider_name = dependency.api_asg.outputs.name
  enable_code_deploy = true

  load_balancer_config = {
    container_name        = string
    blue_target_group_arn = string
    container_port        = number
    sg_id                 = string
  }
}



