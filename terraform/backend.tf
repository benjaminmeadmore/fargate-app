terraform {
  backend "local" {
    path = "flask-app.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.30.0"
    }
  }
}

data "aws_iam_role" "task_ecs" {
  name = "ecsTaskExecutionRole"
}

data "aws_vpc" "default_vpc" {
  default = true
}

# data "aws_subnets" "subnets" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.default_vpc.id]
#   }
# }



