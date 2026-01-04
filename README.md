# GitHub Actions CI/CD Pipeline for ECS Deployment using Terraform

---

## Table of Contents
1. [Project Description](#project-description)  
2. [Architecture](#architecture)  
3. [Project Structure](#project-structure)  
   - [Application Files](#application-files)  
   - [Terraform Infrastructure Code](#terraform-infrastructure-code)  
     - [Root Terraform Files](#root-terraform-files)  
     - [Terraform Modules](#terraform-modules)  
     - [Supporting Terraform Files](#supporting-terraform-files)  
4. [Terraform Commands](#terraform-commands)  
5. [Validating AWS Infrastructure](#validating-aws-infrastructure)  
6. [GitHub Actions CI/CD Pipeline](#github-actions-cicd-pipeline)  
7. [Clean Up](#clean-up)  
8. [Troubleshooting](#troubleshooting)  

---

## Project Description
This project implements a **secure CI/CD pipeline** using GitHub Actions, Terraform, and AWS ECS Fargate.  

All infrastructure, including **VPC networking, IAM roles, ECR, ECS cluster & services**, and **ALB**, is provisioned via Terraform.  

The pipeline uses GitHub-hosted runners and **OIDC-based IAM role access** to build Docker images, push them to ECR, and deploy updates to ECS Fargate.

---

## Architecture

<p align="center">
  <img src="./diagram/Architecture Diagram.png" alt="Architecture Diagram" width="900">
</p>

The architecture provides a modular, secure deployment flow:

- **GitHub Actions**: CI/CD pipeline executed on hosted runners  
- **Terraform**: Infrastructure as Code for AWS provisioning  
- **AWS ECS Fargate**: Container orchestration without managing servers  
- **ECR**: Container image registry  
- **ALB**: Load balancer for exposing the application  

---

## Project Structure

### Application Files
- **app.js**: Node.js entry point, uses Express to serve `/public`, includes `/health` endpoint  
- **package.json**: Node.js dependencies and scripts  
- **public/index.html**: Static UI to verify deployment  
- **Dockerfile**: Multi-stage Docker build exposing port 3000  
- **.github/workflows/deploy.yml**: GitHub Actions pipeline definition  

### Terraform Infrastructure Code
Modular Terraform setup for **VPC, IAM, ECR, ECS, and ALB**.

#### Root Terraform Files
- **terraform.tf**: Terraform & AWS provider, remote S3 state backend  
- **main.tf**: Orchestrates all modules (VPC, IAM, ECR, ALB, ECS)  
- **variables.tf**: Input variables for all modules  
- **terraform.tfvars**: Environment-specific configurations  
- **outputs.tf**: Exposes outputs like ALB DNS  

#### Terraform Modules
- **VPC Module**: Custom VPC, public/private subnets, NAT & IGW, route tables, security groups  
- **IAM Module**: ECS Task Execution role, GitHub OIDC IAM role  
- **ECR Module**: Private ECR repository for Docker images  
- **ALB Module**: Internet-facing Application Load Balancer  
- **ECS Module**: ECS cluster, task definition, service, CloudWatch logging  

#### Supporting Terraform Files
- **github_policy.json**: IAM permissions for GitHub Actions  
- **ecs_policy.json**: IAM permissions for ECS tasks  

---

## Terraform Commands
```bash
terraform init       # Initialize Terraform
terraform validate   # Validate syntax & config
terraform plan       # Preview resource creation
terraform apply      # Provision AWS infrastructure
terraform destroy    # Remove all provisioned resources
```

---

## Validating AWS Infrastructure

### VPC & Networking
- Check VPC, subnets (public & private), route tables, NAT & Internet Gateway  
- Verify security groups for ALB & ECS tasks  

### IAM
- GitHub Actions IAM role with OIDC trust  
- ECS Task Execution role with ECR and CloudWatch permissions  

### ECR
- Private repository exists, ready to receive Docker images  

### ECS
- ECS cluster exists with Container Insights  
- Task definition & service configured for Fargate  
- ALB target group attached  

### ALB
- Internet-facing ALB with HTTP listener forwarding to ECS tasks  

---

## GitHub Actions CI/CD Pipeline

### Key Features
- **OIDC authentication**: No stored AWS secrets  
- **Docker build & push** to ECR  
- **Rolling ECS deployment** with zero downtime  
- **Manual workflow trigger** for controlled releases  

### Workflow Steps
1. Checkout source code  
2. Configure AWS credentials via OIDC  
3. Authenticate to Amazon ECR  
4. Build Docker image  
5. Push Docker image to ECR  
6. Deploy to ECS  

### Post-Deployment Validation
- GitHub Actions workflow success  
- ECR contains the latest image  
- ECS service updates tasks successfully  
- Application accessible via ALB DNS  

---

## Clean Up
Use the command below to destroy all AWS resources:

```bash
terraform destroy --auto-approve
```

---

## Troubleshooting
**Error:** `Could not assume role with OIDC`  
**Cause:** Incorrect repository name in IAM trust policy  
**Solution:** Update IAM trust policy with the correct GitHub repository and reapply Terraform  

---

## Access Application
Once deployed, access the app via ALB DNS.

