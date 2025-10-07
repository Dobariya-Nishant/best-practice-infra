include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

terraform {
  source = "${get_path_to_repo_root()}/modules/aws/deploy/ecs"
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
  name = include.env.inputs.project_name
  auto_scaling_groups = {
    api = {
      name            = "api"
      arn             = dependency.api_asg.outputs.arn
      target_capacity = 100
    }
  }
}