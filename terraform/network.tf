# Get all subnets in the VPC
data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

# Get private subnets for ECS tasks
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

# Get public subnets for ALB
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

# Get existing VPC Endpoint for ECR API
data "aws_vpc_endpoint" "ecr_api" {
  vpc_id       = data.aws_vpc.default_vpc.id
  service_name = "com.amazonaws.${var.aws_region}.ecr.api"
}

# Get existing VPC Endpoint for ECR Docker
data "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id       = data.aws_vpc.default_vpc.id
  service_name = "com.amazonaws.${var.aws_region}.ecr.dkr"
}

# Get existing VPC Endpoint for S3
data "aws_vpc_endpoint" "s3" {
  vpc_id       = data.aws_vpc.default_vpc.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
}

# Get existing route table for private subnets
data "aws_route_table" "private" {
  vpc_id = data.aws_vpc.default_vpc.id
  filter {
    name   = "association.subnet-id"
    values = data.aws_subnets.private.ids
  }
}

# Security group for VPC endpoints
resource "aws_security_group" "vpc_endpoints" {
  name_prefix = "${var.app_name}-vpc-endpoints-"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  tags = merge(local.default_tags, {
    Name = "${var.app_name}-vpc-endpoints-sg"
  })
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

  tags = merge(local.default_tags, {
    Name = "${var.app_name}-alb-sg"
  })
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

  tags = merge(local.default_tags, {
    Name = "${var.app_name}-ecs-sg"
  })
}

# Output for debugging
output "vpc_id" {
  value = data.aws_vpc.default_vpc.id
}

output "all_subnet_ids" {
  value = data.aws_subnets.all.ids
}

output "private_subnet_ids" {
  value = data.aws_subnets.private.ids
}

output "public_subnet_ids" {
  value = data.aws_subnets.public.ids
}