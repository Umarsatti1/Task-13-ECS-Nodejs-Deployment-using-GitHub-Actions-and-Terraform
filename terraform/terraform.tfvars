# VPC Module Vars
vpc_cidr     = "192.168.0.0/16"
vpc_name     = "umarsatti-vpc"
igw_name     = "umarsatti-igw"
eip_domain   = "vpc"
public_route = "0.0.0.0/0"

# IAM Module Vars
ecs_role      = "ecs-task-github-actions-role"
ecs_policy    = "ecs-task-github-actions-policy"
github_role   = "github-actions-iam-role-for-ecs"
github_policy = "github-actions-iam-policy-for-ecs"
github_repo   = "Umarsatti1/Task-13-ECS-Nodejs-Deployment-using-GitHub-Actions-and-Terraform"
github_branch = "main"

# ECR Module Vars
ecr_repo_name  = "nodejs-app"
ecr_mutability = "MUTABLE"
ecr_encryption = "AES256"

# ALB Module Vars
lb_name           = "alb-ecs-github-actions"
lb_type           = "application"
tg_name           = "ecs-target-group"
tg_port           = 3000
tg_protocol       = "HTTP"
protocol_version  = "HTTP1"
tg_type           = "ip"
listener_port     = 80
listener_protocol = "HTTP"
listener_type     = "forward"

# ECS Module Vars
log_group_name       = "ecs-github-actions-nodejs-logs"
task_definition_name = "nodejs-task-definition"
network_mode         = "awsvpc"
launch_type          = "FARGATE"
task_cpu             = "512"
task_memory          = "1024"
container_name       = "nodejs"
cluster_name         = "nodejs-cluster"
service_name         = "nodejs-service"