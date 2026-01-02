# 1. ECS Task Execution IAM Role

# ECS Trust Relationship
data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# ECS IAM Role
resource "aws_iam_role" "ecs_task_role" {
  name               = var.ecs_role
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

# ECS Custom IAM Policy (from external JSON document)
resource "aws_iam_policy" "ecs_policy" {
  name        = var.ecs_policy
  description = "ECS task policy for GitHub Actions workload"

  policy = file("${path.root}/ecs_policy.json")
}

# Attach ECS Custom Inline Policy
resource "aws_iam_role_policy_attachment" "ecs_task_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_policy.arn
}

# 2. GitHub Actions IAM Role

# GitHub Actions OIDC Provider
data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.github_repo}:ref:refs/heads/${var.github_branch}"
      ]
    }
  }
}

resource "aws_iam_role" "github_actions_role" {
  name               = var.github_role
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json
}

# GitHub Actions Custom IAM Policy (from external JSON document)

resource "aws_iam_policy" "github_actions_policy" {
  name        = var.github_policy
  description = "Permissions for GitHub Actions to deploy to ECS"
  policy = templatefile(
    "${path.root}/github_policy.json",
    {
      ecs_task_execution_role_arn = aws_iam_role.ecs_task_role.arn
    }
  )
}

# Attach GitHub Actions Custom Inline Policy
resource "aws_iam_role_policy_attachment" "github_actions_attach" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_actions_policy.arn
}