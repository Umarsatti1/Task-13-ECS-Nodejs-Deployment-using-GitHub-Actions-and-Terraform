# VPC Module
variable "vpc_cidr" {
  type        = string
  description = "VPC IPv4 CIDR block"
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
}

variable "igw_name" {
  type        = string
  description = "Internet gateway name"
}

variable "eip_domain" {
  type        = string
  description = "Elastic IP domain"
}

variable "public_route" {
  type        = string
  description = "All traffic 0.0.0.0/0"
}

# IAM Module
variable "ecs_role" {
  type        = string
  description = "ECS Task Execution IAM role name"
}

variable "ecs_policy" {
  type        = string
  description = "ECS Task Execution IAM policy name"
}

variable "github_role" {
  type = string
}

variable "github_policy" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "github_branch" {
  type = string
}

# ECR Module
variable "ecr_repo_name" {
  type        = string
  description = "ECR private repository name"
}

variable "ecr_mutability" {
  type        = string
  description = "ECR repository mutability option"
}

variable "ecr_encryption" {
  type        = string
  description = "ECR repository encryption type"
}

# ALB Module
variable "lb_name" {
  type        = string
  description = "Load balancer name"
}

variable "lb_type" {
  type        = string
  description = "Load balancer type"
}

variable "tg_name" {
  type        = string
  description = "Target group name"
}

variable "tg_port" {
  type        = number
  description = "Target group port"
}

variable "tg_protocol" {
  type        = string
  description = "Target group protocol"
}

variable "protocol_version" {
  type        = string
  description = "Target group protocol version"
}

variable "tg_type" {
  type        = string
  description = "Target group type"
}

variable "listener_port" {
  type        = number
  description = "Listener port"
}

variable "listener_protocol" {
  type        = string
  description = "Listener protocol"
}

variable "listener_type" {
  type        = string
  description = "Listener type"
}

# ECS Module
variable "log_group_name" {
  type        = string
  description = "CloudWatch log group name"
}

variable "task_definition_name" {
  type        = string
  description = "Task definition family name"
}

variable "network_mode" {
  type        = string
  description = "ECS network mode"
}

variable "launch_type" {
  type        = string
  description = "ECS launch type"
}

variable "task_cpu" {
  type        = string
  description = "ECS Tasks CPU size"
}

variable "task_memory" {
  type        = string
  description = "ECS Tasks memory size"
}

variable "container_name" {
  type        = string
  description = "ECS Task container name"
}

variable "cluster_name" {
  type        = string
  description = "ECS Cluster name"
}

variable "service_name" {
  type        = string
  description = "ECS Service name"
}