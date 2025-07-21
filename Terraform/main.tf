provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "langflow_ec2" {
  ami = "ami-053b0d53c279acc90"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id  
  vpc_security_group_ids      = [aws_security_group.langflow_sg.id]  
  key_name                    = aws_key_pair.langflow_key.key_name 
  associate_public_ip_address = true

  tags = {
    Name = "LangflowEC2"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_policy_attachment" "ecs_execution_attach" {
  name       = "ecs-task-execution-policy"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_ecs_cluster" "langflow_cluster" {
  name = "langflow-cluster"
}

resource "aws_ecs_task_definition" "langflow_task" {
  family                   = "langflow-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "langflow-container"
      image     = "nginx" # Replace with your ECR image URI
      portMappings = [{
        containerPort = 80
        protocol      = "tcp"
      }]
    }
  ])
}

resource "aws_ecs_service" "langflow_service" {
  name            = "langflow-service"
  cluster         = aws_ecs_cluster.langflow_cluster.id
  task_definition = aws_ecs_task_definition.langflow_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.public.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_sg.id]
  }

  depends_on = [aws_iam_policy_attachment.ecs_execution_attach]
}


resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_ecr_repository" "langflow_repo" {
  name = "langflow-ecr"
}


resource "tls_private_key" "langflow_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "langflow_key" {
  key_name   = "langflow-key"
  public_key = tls_private_key.langflow_key.public_key_openssh
}

output "private_key_pem" {
  value     = tls_private_key.langflow_key.private_key_pem
  sensitive = true
}


#resource "aws_vpc" "main" {
 # cidr_block = "10.0.0.0/16"
#}

#resource "aws_subnet" "public_subnet" {
 # vpc_id                  = aws_vpc.main.id
  #cidr_block              = "10.0.1.0/24"
  #availability_zone       = "us-east-1a"
  #map_public_ip_on_launch = true
#}

#resource "aws_internet_gateway" "igw" {
 # vpc_id = aws_vpc.main.id
#}

#resource "aws_route_table" "public_rt" {
 # vpc_id = aws_vpc.main.id

  #route {
   # cidr_block = "0.0.0.0/0"
    #gateway_id = aws_internet_gateway.igw.id
  #}
#}

#resource "aws_route_table_association" "a" {
 # subnet_id      = aws_subnet.public_subnet.id
  #route_table_id = aws_route_table.public_rt.id
#}

resource "aws_security_group" "langflow_sg" {
  name        = "langflow_sg"
  description = "Allow inbound HTTP and SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 7860
    to_port     = 7860
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



