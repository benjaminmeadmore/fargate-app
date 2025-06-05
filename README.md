# flask 'hello-world' app w/ AWS Fargate Deployment

This project demonstrates a Flask application deployed on AWS Fargate using Terraform for infrastructure management and GitHub Actions for CI/CD.

## Architecture Overview

The application is deployed as a containerized Flask service running on AWS Fargate, with the following components:
- Flask application with security features (CORS, rate limiting, security headers)
- Docker containerization with multi-stage builds
- AWS Fargate for serverless container deployment
- Application Load Balancer for traffic distribution
- ECR for Docker image storage
- GitHub Actions for CI/CD pipeline

## Development Workflow

### Local Development
1. Clone the repository
2. Create a virtual environment: `python -m venv venv`
3. Activate the virtual environment:
   - Windows: `venv\Scripts\activate`
   - Unix/MacOS: `source venv/bin/activate`
4. Install dependencies: `pip install -r requirements.txt`
5. Copy `.env.example` to `.env` and configure your environment variables
6. Run the application: `flask run`

### Deployment Process
1. Create a feature branch
2. Make your changes
3. Create a pull request
4. GitHub Actions will automatically:
   - Run tests and linting
   - Build Docker image
   - Push to ECR
   - Deploy infrastructure changes
5. After merging to main:
   - GitHub Actions will redeploy automatically
   - Update ECS service with the new image

## Infrastructure

The infrastructure is managed using Terraform and includes:
- ECS Fargate cluster
- Application Load Balancer
- ECR repository
- Security groups and IAM roles
- VPC and networking components

### Important Infrastructure Notes
- Uses local state file: `./terraform/flask-app.tfstate`
- Limited to 2 replicas as per requirements
- Uses existing deafult vpc and two private subnets
- Includes proper health checks
- Configured with appropriate sgrs

## Security Features

The application includes several security measures:
- HTTPS enforcement
- CORS protection
- Rate limiting
- Security headers (CSP, HSTS)
- Non-root user in Docker container
- Environment variable management
- Health check endpoints

## CI/CD Pipeline

### Pull Request Workflow
- Runs on pull request creation
- Executes tests and linting
- Builds and tests Docker image
- Prevents merging if tests fail

### Deployment Workflow
- Triggers on merge to main
- Validates Terraform configuration
- Plans infrastructure changes
- Applies changes if plan is approved
- Updates ECS service with new image

## Pending Improvements

The following improvements are planned:
- [ ] Set up route tables and internet gateway
- [ ] Configure ECS auto-scaling
- [ ] Implement CloudWatch logging (aws_role iam perms required)
- [X] Add infrastructure tags
- [ ] Add security scanning (Trivy)
- [ ] Add Terraform linting (tflint)
- [ ] Implement drift detection
- [ ] Add plan caching
- [ ] Improve plan output parsing with jq 

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform installed
- Docker installed
- Python 3.11+
- GitHub account with repository access

## Environment Variables

Required environment variables (see `.env.example`):
- `FLASK_APP`: Application entry point
- `FLASK_ENV`: Environment (development/production)
- `APP_VERSION`: Application version
- `ALLOWED_ORIGINS`: CORS allowed origins
- `AWS_REGION`: AWS region
- `AWS_ACCESS_KEY_ID`: AWS access key
- `AWS_SECRET_ACCESS_KEY`: AWS secret key

## License

This project is licensed under the MIT License - see the LICENSE file for details. 