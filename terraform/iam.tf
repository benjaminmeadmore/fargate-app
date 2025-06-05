# Data source for existing ECS task execution role
data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

# Additional task role for application-specific permissions
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.app_name}-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.app_name}-task-role"
  }
}

# Policy for CloudWatch Logs access
resource "aws_iam_policy" "ecs_logging" {
  name        = "${var.app_name}-logging-policy"
  description = "Allow ECS tasks to write to CloudWatch Logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.aws_region}:*:log-group:/ecs/${var.app_name}:*"
      }
    ]
  })
}

# Attach logging policy to task role
resource "aws_iam_role_policy_attachment" "ecs_task_logging" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_logging.arn
}

# Output role ARNs
output "ecs_task_execution_role_arn" {
  value = data.aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}