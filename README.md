# flask 'hello-world' app w/ AWS Fargate Deployment

This project demonstrates a Flask application deployed on AWS Fargate using Terraform for IaC and GitHub Actions for CI/CD.

## Test

You can access the app at:
http://flask-app-tf-alb-1028148465.eu-north-1.elb.amazonaws.com/

## Overview

The app is deployed as a containerized Flask service running on AWS Fargate, with the following components:
- Flask application with security features (CORS, rate limiting, security headers)
- Docker containerization with multi-stage builds using gunicorn
- AWS Fargate for serverless container deployment
- Application Load Balancer for traffic distribution
- ECR for Docker image storage
- GitHub Actions for CI/CD pipeline

### API Endpoints
- The root endpoint (`/`) responds with a friendly "Hello, World" message
- The health check endpoint (`/health`) confirms everything is running properly with version 1.0.0

### Core Features
All the essential features are working as expected:
- The Flask application is running smoothly
- Rate limiting is properly configured to protect against abuse
- CORS is enabled for secure cross-origin requests
- Security headers are in place thanks to Talisman
- The load balancer is correctly routing traffic
- Health checks are passing consistently
- The application has proper internet connectivity

### Important Infrastructure Notes
- Uses local state file: `./terraform/flask-app.tfstate`
- Limited to 2 replicas as per requirements
- Uses existing default_vpc, two subnets, an igw and rtable
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