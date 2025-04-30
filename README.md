# docker-php-laravel-aws-base-image

A reusable Docker base image for Laravel applications, pre-configured for deployment to AWS ECS. This project includes a Makefile-based local development workflow, CI/CD integration via AWS CodeBuild, and automated ECR image publishing.

## Features

- ✅ PHP 8.x and Laravel 12.x compatible  
- 🐳 Lightweight Dockerfile optimized for Laravel  
- 🔐 Secrets pulled securely from AWS Secrets Manager  
- 🚀 Pushes tagged images to Amazon ECR  
- ⚙️ Includes Makefile commands for build & push  
- 🔁 Ready for use in CodeBuild & CodePipeline workflows

## Usage

### Build locally

```bash
make build
```

### Push to ECR

```bash
make push
```

### Customize

- Edit the `SECRET_ID` in the Makefile to match your AWS Secrets Manager secret name.
- Edit the `SECRET_ID` and add your aws account id in the buildspec.yml to match your AWS Secrets Manager secret name and AWS credentials.
