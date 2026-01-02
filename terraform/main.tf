# VPC
module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = var.vpc_cidr
  vpc_name     = var.vpc_name
  igw_name     = var.igw_name
  eip_domain   = var.eip_domain
  public_route = var.public_route
}

# IAM
module "iam" {
  source        = "./modules/iam"
  ecs_role      = var.ecs_role
  ecs_policy    = var.ecs_policy
  github_role   = var.github_role
  github_policy = var.github_policy
  github_repo   = var.github_repo
  github_branch = var.github_branch
}

# ECR
module "ecr" {
  source         = "./modules/ecr"
  ecr_repo_name  = var.ecr_repo_name
  ecr_mutability = var.ecr_mutability
  ecr_encryption = var.ecr_encryption
}

# ALB
module "alb" {
  source            = "./modules/alb"
  lb_name           = var.lb_name
  lb_type           = var.lb_type
  tg_name           = var.tg_name
  tg_port           = var.tg_port
  tg_protocol       = var.tg_protocol
  protocol_version  = var.protocol_version
  tg_type           = var.tg_type
  listener_port     = var.listener_port
  listener_protocol = var.listener_protocol
  listener_type     = var.listener_type
  vpc_id            = module.vpc.vpc_id
  alb_sg            = module.vpc.alb_sg_id
  alb_subnet        = module.vpc.public_subnets
}

# ECS
module "ecs" {
  source                  = "./modules/ecs"
  log_group_name          = var.log_group_name
  task_definition_name    = var.task_definition_name
  network_mode            = var.network_mode
  launch_type             = var.launch_type
  task_cpu                = var.task_cpu
  task_memory             = var.task_memory
  container_name          = var.container_name
  cluster_name            = var.cluster_name
  service_name            = var.service_name
  ecs_task_execution_role = module.iam.ecs_task_exec_role
  ecr_image_uri           = module.ecr.ecr_image_uri
  ecs_sg                  = module.vpc.ecs_sg_id
  ecs_subnets             = module.vpc.private_subnets
  target_group_arn        = module.alb.target_group_arn
}