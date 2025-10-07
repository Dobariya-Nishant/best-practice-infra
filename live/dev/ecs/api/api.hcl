dependency "vpc" {
  config_path = "${dirname(find_in_parent_folders("env.hcl"))}/vpc"

  mock_outputs = {
    id                 = "mock-vpc-id"
    public_subent_ids  = ["subnet-mock1", "subnet-mock2"]
    private_subent_ids = ["subnet-mock1", "subnet-mock2"]
  }
}

inputs = {
  vpc_id     = dependency.vpc.outputs.id
  subnet_ids = dependency.vpc.outputs.private_subent_ids
}
