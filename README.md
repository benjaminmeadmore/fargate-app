# 'hello-world' flask app w/ Terraform

This project is an example of deploying a containerized flask service running on [ECS Fargate](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html), with [Github Actions](https://github.com/features/actions) triggering orchestration and [Terraform](https://www.terraform.io/) for provisioning.

All in all it was a fun project to work on over one week - having not worked with ECS too much in the past getting the containers activated correctly was a cruel master. As always, networking reamins the most challenging aspect from any abstracted point of view. Definitely learnt alot along the way! 

## Usage

You can test out the app at:
http://flask-app-tf-alb-1028148465.eu-north-1.elb.amazonaws.com/

API Endpoints
- The root endpoint (`/`) responds with a "Hello, World" message
- The health check endpoint (`/health`) confirms everything is running properly with version 1.0.0

## Overview

- The flask application itself has some basic security features (CORS, rate limiting, security headers)
- Docker build runs as non-root and uses gunicorn
- ECS service defines 2 tasks for deployment, each assigned public IPs in subnets of a default_vpc in eu-north-1
- ALB listens on 80 for HTTP traffic distribution
- ECR stores the image 
- GitHub Actions for deploy and pr-testing pipelines
- Uses local Tf state file: `./terraform/flask-app.tfstate`

## CI/CD Pipeline

### Pull Request Workflow
- Runs on pull request creation
- Executes tests and linting
- Builds and tests Docker image
- Prevents merging if tests fail

### Tf Deployment Workflow
- Triggers on merge to main, runs the following jobs:
   - validate & fmt 
   - plan infrastructure changes
   - apply changes if plan is approved
   - update ECS service with new image
   - destroy (manual trigger)

## Environment Variables
Required environment variables (see `.env.example`):
- `FLASK_APP`: Application entry point
- `FLASK_ENV`: Environment (development/production)
- `APP_VERSION`: Application version
- `ALLOWED_ORIGINS`: CORS allowed origins
- `AWS_REGION`: AWS region
- `AWS_ACCESS_KEY_ID`: AWS access key
- `AWS_SECRET_ACCESS_KEY`: AWS secret key

## Future Thoughts

- Github 
   - Lowest hanging fruit with more time would be to rework the deploy.yml pipeline to add the following: 
      - security scanning (Trivy - the amount of high and critical issues this would throw up would be daunting)
      - linting (tflint)
      - drift detection (driftctl)
      - plan output parsing (jq) 
      - plan caching (S3)
      - Use the latest alpine image for a more lightweight/faster container (current build ~2mins) 

- ALB
   - I would definitely add an SSL certificate manager based on a private domain
   - I would add another listener for HTTPS and redirect HTTP traffic as well 
   - Depending on how available I wanted the service to be I would add a threshold for desired healthy instances and provision more app servers 

- Then on the Tf side of things: 
   - Reconfigure the repo to use a locals file and modularize the deployment
   - Add remote storage backend in S3 
   - Improve on the ECS deployment with auto-scaling (cost-dependent)

- Security: 
   - Stand up Cloudwatch monitoring for the ecs tasks. This was a huge source of frustration during the build. 
   - Configure the alb to use another target group for HTTPS/SSL 
   - Improve on the ECS deployment with auto-scaling (cost-dependent)

- I couldn't get the health checks to work using curl or wget so for now they are based on python's urllib package. 

## License

This project is licensed under the MIT License - see the LICENSE file for details. 