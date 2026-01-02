# Input Variables
variable "log_group_name" {
  type = string
}

variable "task_definition_name" {
  type = string
}

variable "network_mode" {
  type = string
}

variable "launch_type" {
  type = string
}

variable "task_cpu" {
  type = string
}

variable "task_memory" {
  type = string
}

variable "container_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "service_name" {
  type = string
}

# Reference
variable "ecs_task_execution_role" {
  type = string
}

variable "ecr_image_uri" {
  type = string
}

variable "ecs_sg" {
  type = string
}

variable "ecs_subnets" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}