# flask-app workflow

## Broad step-by-step
☐ Create Terraform infrastructure for AWS Fargate deployment
☐ Set up ECR repository for Docker images
☐ Deploy ECS cluster with Fargate service (2 replicas)
☐ Create GitHub Actions workflow for CI/CD
☐ Set up PR testing and linting workflow
☐ Set up deployment workflow on merge to main

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

## To Do & Discuss
- Set up route tables and internet gateway ?
- Set up ECS auto-scaling ?
- Configure logging to CloudWatch ? I believe my IAM user lacks these permissions 
~- Add tags ~
- Add steps in validate for trivy, tflint and possibly drift
- Add jq to plan stage, parse human-readable summary of plan (i.e. CUD steps)
- Add cache a cpoy of the plan



