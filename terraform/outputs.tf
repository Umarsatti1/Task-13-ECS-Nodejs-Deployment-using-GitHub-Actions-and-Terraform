output "alb_dns" {
  value       = module.alb.load_balancer_dns
  description = "ALB DNS name for application access"
}