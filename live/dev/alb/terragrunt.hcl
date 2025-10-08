include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

terraform {
  source = "${get_path_to_repo_root()}/modules/aws/compute/alb"
}

dependency "vpc" {
  config_path = "${dirname(find_in_parent_folders("env.hcl"))}/vpc"

  mock_outputs = {
    id                 = "mock-vpc-id"
    public_subent_ids  = ["subnet-mock1", "subnet-mock2"]
    private_subent_ids = ["subnet-mock1", "subnet-mock2"]
  }
}

dependency "route53" {
  config_path = "${get_path_to_repo_root()}/live/global/route53"

  mock_outputs = {
    hostedzone_id       = "mock-hostedzone-id"
    domain_name         = "mock-domain-name"
    hostedzone_arn      = "arn:aws:autoscaling:us-east-1:123456789012:mock:uuid:mock/mock"
    acm_certificate_arn = "arn:aws:autoscaling:us-east-1:123456789012:mock:uuid:mock/mock"
  }
}

inputs = {
  name       = include.env.inputs.project_name
  vpc_id     = dependency.vpc.outputs.id
  subnet_ids = dependency.vpc.outputs.public_subent_ids

  acm_certificate_arn = dependency.route53.outputs.acm_certificate_arn
  hostedzone_id       = dependency.route53.outputs.hostedzone_id
  domain_names        = [dependency.route53.outputs.domain_name]

  target_groups = {
    web = {
      name        = "web"
      port        = 80
      protocol    = "HTTP"
      target_type = "ip"
    }
    api = {
      name        = "api"
      port        = 80
      protocol    = "HTTP"
      target_type = "ip"
    }
  }

  listener = {
    name             = "activatree"
    target_group_key = "web"
    rules = {
      api_rule = {
        description      = "api path routing"
        target_group_key = "api"
        patterns         = ["/api*"]
      }
    }
  }
}
