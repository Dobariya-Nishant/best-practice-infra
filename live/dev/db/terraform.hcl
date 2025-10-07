include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

terraform {
  source = "${get_path_to_repo_root()}/modules/aws/storage/documentDB"
}

dependency "vpc" {
  config_path = "${dirname(find_in_parent_folders("env.hcl"))}/vpc"

  mock_outputs = {
    id                 = "mock-vpc-id"
    public_subent_ids  = ["subnet-mock1", "subnet-mock2"]
    private_subent_ids = ["subnet-mock1", "subnet-mock2"]
  }
}

inputs = {
  name                = include.env.inputs.project_name
  vpc_id              = dependency.vpc.outputs.id
  subnet_ids          = dependency.vpc.outputs.private_subent_ids
  skip_final_snapshot = true
}