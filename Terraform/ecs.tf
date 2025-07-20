resource "aws_ecs_task_definition" "langflow" {
  family                   = "langflow-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "langflow"
      image     = aws_ecr_repository.langflow.repository_url
      essential = true
      portMappings = [
        {
          containerPort = 7860
          hostPort      = 7860
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/langflow"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
      secrets = [
        {
          name      = "LANGCHAIN_API_KEY"
          valueFrom = "arn:aws:ssm:us-east-1:<account-id>:parameter/LANGCHAIN_API_KEY" # account id removed before uploading code to git
        },
        {
          name      = "OPENAI_API_KEY"
          valueFrom = "arn:aws:ssm:us-east-1:<account-id>:parameter/OPENAI_API_KEY"       # account id removed before uploading code to git
        },
        {
          name      = "LANGFLOW_ENV"
          valueFrom = "arn:aws:ssm:us-east-1:<account-id>:parameter/LANGFLOW_ENV"   # account id removed before uploading code to git
        }
      ]
    }
  ])
}

