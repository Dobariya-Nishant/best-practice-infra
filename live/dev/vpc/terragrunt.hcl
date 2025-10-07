include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

terraform {
  source = "${get_path_to_repo_root()}/modules/aws/network/vpc"
}

inputs = {
  name               = include.env.inputs.project_name
  cidr_block         = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  enable_nat_gateway = true
}
