output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "VPC ID"
}

output "public_subnets" {
  value       = [for subnet in aws_subnet.public_subnet : subnet.id]
  description = "VPC public subnet IDs"
}

output "private_subnets" {
  value       = [for subnet in aws_subnet.private_subnet : subnet.id]
  description = "VPC private subnet IDs"
}

output "alb_sg_id" {
  value       = aws_security_group.alb_sg.id
  description = "ALB security group ID"
}

output "ecs_sg_id" {
  value       = aws_security_group.ecs_sg.id
  description = "ECS security group ID"
}