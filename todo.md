# flask-app workflow

## Broad step-by-step
☐ Create Terraform infrastructure for AWS Fargate deployment
☐ Set up ECR repository for Docker images
☐ Deploy ECS cluster with Fargate service (2 replicas)
☐ Create GitHub Actions workflow for CI/CD
☐ Set up PR testing and linting workflow
☐ Set up deployment workflow on merge to main

# AWS Fargate Deployment Guide
## Prerequisites
- AWS CLI configured with profile 'benmea'
- Docker image built and tested locally
- GitHub repository with branch protection rules set up (flask-app-tf remote origin) 
- GitHub Actions secrets configured (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)

## Step 0: Explore setup
1. Explore the ./terraform directory for ingesting blank .tf file structure & local backend configuration
   - Import cmds will need to be used for the: 
      - arn:aws:iam::303981612052:role/ecsTaskExecutionRole
      - `303981612052.dkr.ecr.eu-north-1.amazonaws.com/flaskdemo`
      - vpc-02052c2eb890946a4

## Step 1: ECR Repository Setup
1. Create `ecr.tf` to configure the existing ECR repository:
   - Use the provided ECR URI: `303981612052.dkr.ecr.eu-north-1.amazonaws.com/flaskdemo`
   - Configure repository policy for GitHub Actions access
   - Set up lifecycle policy for image retention

## Step 2: Network Configuration
1. Create `network.tf` to set up networking components:
   - Use the existing VPC (vpc-02052c2eb890946a4, as specified in README)
   - Create security groups:
     * ALB security group (port 80 ingress)
     * ECS tasks security group (port 5000 ingress from ALB)
   - Configure subnets using existing VPC subnets
   - 

## Step 3: Load Balancer Setup
1. Create `alb.tf` to configure the Application Load Balancer:
   - Create ALB in public subnets
   - Configure target group for port 5000
   - Set up HTTP listener on port 80
   - Configure health check path
   - Set up security group rules

## Step 4: ECS Cluster and Service
1. Create `ecs.tf` to set up the container infrastructure:
   - Create ECS cluster
   - Define task definition:
     * Use Fargate launch type
     * Configure container port 5000
     * Set up environment variables
   - Create ECS service:
     * Set desired count to 2
     * Configure load balancer integration
   - Use existing ecsTaskExecutionRole

## Step 5: IAM Roles and Policies
1. Create `iam.tf` to set up necessary permissions:
   - Configure task execution role (import and use arn:aws:iam::303981612052:role/ecsTaskExecutionRole)
   - Set up task role for application permissions
   - Set up ECR pull permissions

## Step 6: Variables and Outputs
1. Create `variables.tf` for configurable values:
   - AWS region (eu-north-1)
   - ECR repository URI (303981612052.dkr.ecr.eu-north-1.amazonaws.com/flaskdemo)
   - Container port 
   - Service name (flask-app-tf)
   - Environment variables

2. Create `outputs.tf` for important information:
   - ALB DNS name
   - ECS cluster name
   - Service name
   - Task definition ARN

## Step 7: GitHub Actions Workflow
1. Read `.github/workflows/deploy.yml`:
   - Login to ECR
   - Build and push Docker image
   - Deploy infrastructure using Terraform
   - Update ECS service with new image

## Step 8: Local Testing
1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Create `terraform.tfvars`:
   ```hcl
   aws_region = "eu-north-1"
   ecr_repository = "303981612052.dkr.ecr.eu-north-1.amazonaws.com/flaskdemo"
   ```

3. Plan and apply:
   ```bash
   terraform plan
   terraform apply
   ```

## Step 10: Deployment Process
1. Create feature branch
2. Make changes
3. Create pull request
4. GitHub Actions will:
   - Run tests
   - Build Docker image
   - Push to ECR
   - Deploy infrastructure
5. After merge to main:
   - GitHub Actions will redeploy
   - Update ECS service with new image

## Important Notes
- Use local state file as specified in README ./terraform/flask-app.tfstate
- Ensure proper error handling in GitHub Actions
- Set up proper health checks
- Configure proper security group rules
- Use existing VPC and subnets
- Limit to 2 replicas as per requirements

## To Discuss
☐ Set up route tables and internet gateway ?
☐ Set up ECS auto-scaling ?
☐ Configure logging to CloudWatch ? I believe my IAM user lacks these permissions 



