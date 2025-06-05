data "aws_vpc" "default_vpc" {
  id = var.default_vpc_id
}

# Get public subnets for ALB
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}

# Get private subnets for ECS tasks
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["false"]
  }
}

# Security group for ALB
resource "aws_security_group" "alb" {
  name_prefix = "${var.app_name}-alb-"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-alb-sg"
  }
}

# Security group for ECS tasks
resource "aws_security_group" "ecs_tasks" {
  name_prefix = "${var.app_name}-ecs-"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-ecs-sg"
  }
}