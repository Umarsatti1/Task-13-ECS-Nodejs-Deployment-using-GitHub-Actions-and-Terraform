# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = var.log_group_name
  retention_in_days = 7
}

# ECS Task Definition
resource "aws_ecs_task_definition" "task_definition" {
  family                   = var.task_definition_name
  network_mode             = var.network_mode
  requires_compatibilities = [var.launch_type]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.ecs_task_execution_role
  task_role_arn            = var.ecs_task_execution_role

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = "${var.ecr_image_uri}:latest"
      essential = true
      cpu       = 256
      memory    = 512

      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = "us-west-1"
          awslogs-stream-prefix = "nodejs-app"
        }
      }
    }
  ])
}

# ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enhanced"
  }

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "capacity" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = [var.launch_type]

  default_capacity_provider_strategy {
    base              = 0
    weight            = 1
    capacity_provider = var.launch_type
  }
}

# ECS Service
resource "aws_ecs_service" "service" {
  name                               = var.service_name
  cluster                            = aws_ecs_cluster.ecs_cluster.id
  task_definition                    = aws_ecs_task_definition.task_definition.arn
  desired_count                      = 2
  launch_type                        = var.launch_type
  platform_version                   = "LATEST"
  scheduling_strategy                = "REPLICA"
  enable_execute_command             = true
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 100

  deployment_configuration {
    strategy = "ROLLING"
  }

  network_configuration {
    assign_public_ip = false
    security_groups  = [var.ecs_sg]
    subnets          = var.ecs_subnets
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = 3000
  }
}

