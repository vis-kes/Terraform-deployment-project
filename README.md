Simple Time Service – Terraform AWS ECS Deployment

This project demonstrates infrastructure as code using Terraform to deploy a containerized Node.js application to AWS ECS (EC2 launch type) behind an Application Load Balancer (ALB).
It is designed as a technical demonstration for interview selection, showcasing best practices in cloud automation, networking, and container orchestration


Table of Contents
Project Structure
Features
PrerequisitesFeatures
Terraform-managed AWS infrastructure
Custom VPC with 2 public and 2 private subnets
ECS cluster (EC2 launch type) in private subnets
Auto Scaling Group for ECS instances
Application Load Balancer in public subnets
Secure, modular, and production-ready setup
Node.js app listens on port 3000 (demonstrates non-standard port mapping)


Prerequisites
AWS account with sufficient permissions
AWS CLI installed and configured
Terraform v1.3+ installed
Docker installed (for building/pushing image)
Git installed


Setup Instructions
1. Clone and Authenticate
text
git clone <this-repo-url>
cd <repo-root>
aws configure
Never commit or share your AWS credentials.
2. Build & Push Docker Image
Create an ECR repository (if not already):
text
aws ecr create-repository --repository-name simple-time-service
Authenticate Docker to ECR:
text
aws ecr get-login-password --region ap-south-1 | \
  docker login --username AWS --password-stdin <your-account-id>.dkr.ecr.ap-south-1.amazonaws.com
Build and tag your image:
text
cd app
docker build -t simple-time-service .
docker tag simple-time-service:latest <your-account-id>.dkr.ecr.ap-south-1.amazonaws.com/simple-time-service:latest
Push to ECR:
text
docker push <your-account-id>.dkr.ecr.ap-south-1.amazonaws.com/simple-time-service:latest
Update the image URL in terraform/variables.tf if needed.
3. Configure Terraform Variables
Edit terraform/variables.tf and set your ECR image URL for app_image.
Optionally, adjust VPC/subnet CIDRs as needed.
4. Deploy Infrastructure
text
cd terraform
terraform init
terraform plan
terraform apply
Confirm with yes when prompted.
5. Access the Application
After deployment, Terraform will output the ALB DNS name:
text
alb_dns_name = "app-alb-xxxxxxxx.ap-south-1.elb.amazonaws.com"
Open http://app-alb-xxxxxxxx.ap-south-1.elb.amazonaws.com in your browser.
You should see a JSON response with the current timestamp and your IP.
Application Details
Language: Node.js with Express
Listening Port: 3000 (inside the container)
Health Check: / (returns HTTP 200)

Dockerfile exposes port 3000 and ECS/ALB are configured to forward traffic to port 3000.
Security & Best Practices
No credentials are committed to this repository.
Use environment variables and IAM roles for authentication.
All infrastructure is parameterized with variables and uses Terraform best practices.
Security groups restrict traffic between ALB and ECS tasks.
Cleanup
To avoid ongoing AWS charges, destroy all resources when finished:
text
cd terraform
terraform destroy









