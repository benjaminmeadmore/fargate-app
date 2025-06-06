# flask 'hello-world' app  

This was a fun project to work on - having not worked with ECS too much in the past getting the containers activated correctly was a cruel master. As always, networking reamins the most challenging aspect from an abstraction point of view. Definitely learnt alot along the way! 

## Usage

You can test out the app at:
http://flask-app-tf-alb-1028148465.eu-north-1.elb.amazonaws.com/

API Endpoints
- The root endpoint (`/`) responds with a friendly "Hello, World" message
- The health check endpoint (`/health`) confirms everything is running properly with version 1.0.0

## Overview

The app is deployed as a containerized Flask service running on AWS Fargate, with Github Actions triggering orchestration and Tf for provisioning:
- The flask application itself has basic security features (CORS, rate limiting, security headers)
- Docker containerization with multi-stage builds using gunicorn
- AWS Fargate for serverless container deployment
- Application Load Balancer for traffic distribution
- ECR for Docker image storage
- GitHub Actions for CI/CD pipeline

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

## Thoughts

- Lowest hanging fruit with more time would be to rework the deploy.yml pipeline to add the following: 
   - Add security scanning (Trivy)
   - Add Tf linting (tflint)
   - Implement drift detection (driftctl)
   - Implement plan output parsing (jq) 
   - Add plan caching (S3)
   - Use the latest alpine image for a lighterweight 

- Then on the Tf side of things: 
   - Add remote storage backend (S3)


- I couldn't get the health checks to work using curl or wget so for now they are based on python's urllib package. 



- [ ] Configure ECS auto-scaling
- [ ] Configure the alb to use another target group for HTTPS/SSL 
- [ ] Implement CloudWatch logging (IAM) and VPC flowlogs
- [ ] Add security scanning (Trivy)
- [ ] Add Terraform linting (tflint)
- [ ] Implement drift detection (driftctl)
- [ ] Add remote storage backend (S3)



## License

This project is licensed under the MIT License - see the LICENSE file for details. 