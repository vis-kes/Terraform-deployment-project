variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "app_image" {
  description = "ECR image URL for Node.js app"
  default     = "160893303294.dkr.ecr.ap-south-1.amazonaws.com/simple-time-service:latest"
}

