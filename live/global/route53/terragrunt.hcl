include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_path_to_repo_root()}/modules/aws/network/route53"
}

inputs = {
  project_name = "activatree"
  domain_name  = "dev.activatree.com"
  environment  = "prod"
}
