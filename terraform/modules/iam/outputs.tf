output "ecs_task_exec_role" {
  value       = aws_iam_role.ecs_task_role.arn
  description = "ARN of ECS Task Execution Role"
}

output "github_actions_role" {
  value       = aws_iam_role.github_actions_role.arn
  description = "ARN of GitHub Actions IAM Role (OIDC)"
}