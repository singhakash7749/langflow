# variables.tf

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-south-1" # Set your preferred default region
}

variable "project_name" {
  description = "A unique name for your project, used as a prefix for resources."
  type        = string
  default     = "langflow"
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, production)."
  type        = string
  default     = "dev" # For this assignment, 'dev' is appropriate
}

variable "fargate_cpu" {
  description = "The amount of CPU units (e.g., 256 for 0.25 vCPU) for the Fargate task."
  type        = string
  default     = "256" # Corresponds to 0.25 vCPU
}

variable "fargate_memory" {
  description = "The amount of memory (in MiB, e.g., 512 for 0.5 GB) for the Fargate task."
  type        = string
  default     = "512" # Corresponds to 0.5 GB RAM
}

variable "langflow_port" {
  description = "The port on which the LangFlow application listens inside the container."
  type        = number
  default     = 7860 # Common port for LangFlow/Gradio apps, verify with your Dockerfile
}

variable "container_name" {
  description = "The name given to the LangFlow container within the ECS Task Definition."
  type        = string
  default     = "langflow"
}

variable "github_repo_owner" {
  description = "Your GitHub username (owner of the repository)."
  type        = string
  # Example: default = "your-github-username"
}

variable "github_repo_name" {
  description = "The name of your LangFlow repository on GitHub."
  type        = string
  # Example: default = "langflow" (if you forked it as 'langflow')
}
