output "ecr_image_uri" {
  value       = aws_ecr_repository.ecr_repository.repository_url
  description = "ECR repository image URI"
}