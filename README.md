# 🌿 Terraform Infrastructure

A production-ready **AWS infrastructure-as-code (IaC)** setup built with **Terraform** and **Terragrunt**, following a multi-environment architecture (`dev`, `stag`, `prod`).  
This project provisions a complete **ECS with EC2 launch type**, **Jenkins CI/CD**, **ALB**, **EFS**, and **VPC networking** with modular, reusable Terraform components.

---

## 🧩 Key Features

- ✅ **Multi-environment support** (`dev`, `stag`, `prod`)
- ✅ **Modular Terraform structure** — clean separation between compute, network, storage, and deployment layers
- ✅ **Terragrunt wrappers** for DRY code, dependency injection, and environment management
- ✅ **Blue-Green ECS Deployment** using **AWS CodeDeploy**
- ✅ **Jenkins** hosted on EC2 with **ALB** + **EFS persistent storage**
- ✅ **Route53 Hosted Zone** for domain and subdomain management
- ✅ **Scalable & Secure** — IAM roles, private subnets, managed NAT gateway, and ECS capacity providers

---

## 🏗️ Repository Structure

```bash
.
├── live/                         # Environment-specific stacks
│   ├── dev/
│   │   ├── network/              # VPC, subnets, gateways
│   │   ├── storage/              # EFS & database
│   │   ├── compute/              # ALB, ASG, ECS
│   │   ├── deploy/               # Services (ECS tasks, CodeDeploy)
│   │   ├── env.hcl               # Environment variables (region, tags, etc.)
│   │   └── ...
│   ├── stag/
│   ├── prod/
│   └── global/
│       └── route53/              # Shared Route53 hosted zone
│
├── modules/                      # Reusable Terraform modules
│   ├── aws/
│   │   ├── network/              # VPC, Route53
│   │   ├── compute/              # ECS, ALB, ASG, EC2
│   │   ├── storage/              # EFS, DB, ECR
│   │   └── deploy/               # CodeDeploy & ECS service
│
└── root.hcl                      # Global Terragrunt root configuration
```
