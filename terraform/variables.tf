

# Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "aws_profile" {
  description = "AWS profile to use"
  type        = string
  default     = "benmea"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "flask-app-tf"
}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 5000
}

variable "iam_ecs_task_execution_role_name" {
  description = "IAM Role for ecs permissions"
  type        = string
  default     = "ecsTaskExecutionRole"
}

variable "ecr_repository_url" {
  description = "ECR repository URL"
  type        = string
  default     = "303981612052.dkr.ecr.eu-north-1.amazonaws.com/flaskdemo"
}

variable "default_vpc_id" {
  description = "VPC ID for retrieving subnets"
  type        = string
  default     = "vpc-02052c2eb890946a4"
}