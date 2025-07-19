from aws_cdk import (
    Stack,
    aws_ecs as ecs,
    aws_ecs_patterns as ecs_patterns,
    aws_ecr as ecr,
    aws_iam as iam,
)
from constructs import Construct

class LangflowStack(Stack):
    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # ECR repo
        repository = ecr.Repository.from_repository_arn(
            self,
            "ExistingRepo",
            repository_arn="arn:aws:ecr:us-east-1:YOUR_ACCOUNT_ID:repository/YOUR_REPO_NAME"
        )

        # Fargate cluster
        cluster = ecs.Cluster(self, "Cluster")

        # Task definition with role
        task_role = iam.Role(self, "FargateTaskRole",
            assumed_by=iam.ServicePrincipal("ecs-tasks.amazonaws.com")
        )

        task_def = ecs.FargateTaskDefinition(
            self, "TaskDef",
            cpu=256,
            memory_limit_mib=512,
            task_role=task_role
        )

        container = task_def.add_container(
            "LangflowContainer",
            image=ecs.ContainerImage.from_ecr_repository(repository, "latest"),
            port_mappings=[ecs.PortMapping(container_port=7860)]
        )

        # Fargate service
        ecs.FargateService(
            self, "LangflowService",
            cluster=cluster,
            task_definition=task_def,
            assign_public_ip=True,
        )

