provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

terraform {
  backend "local" {
    path = "./flask-app.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.30.0"
    }
  }
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = var.iam_ecs_task_execution_role_name
}

data "aws_vpc" "default_vpc" {
  id = var.default_vpc_id
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}



