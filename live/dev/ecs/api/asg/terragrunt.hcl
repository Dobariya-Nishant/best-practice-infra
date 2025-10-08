include "env" {
  path = find_in_parent_folders("env.hcl")
}

include "api" {
  path = find_in_parent_folders("api.hcl")
}

terraform {
  source = "${get_path_to_repo_root()}/modules/aws/compute/asg"
}

inputs = {
  name             = "api"
  desired_capacity = 1
  max_size         = 1
  min_size         = 1
  instance_type    = "t3.micro"
  ebs_size         = 30
  ecs_cluster_name = "activatree-cluster-dev"
}