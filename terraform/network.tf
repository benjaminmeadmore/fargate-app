# Get existing internet gateway
data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

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
  
  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

# Get public subnets for ALB
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
  
  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }
}

# Import existing route table that ALB subnets are using
data "aws_route_table" "alb_subnets" {
  route_table_id = "rtb-0c5699cdd4d11d72b"
}

# Add internet gateway route to the ALB subnets route table
resource "aws_route" "alb_internet_access" {
  route_table_id         = data.aws_route_table.alb_subnets.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.aws_internet_gateway.default.id
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