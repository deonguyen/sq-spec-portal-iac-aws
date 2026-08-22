data "aws_caller_identity" "current" {}

data "aws_ecr_repository" "app" {
  for_each = { for k, s in var.services : k => s if s.ecr_repository_name != null }
  name     = each.value.ecr_repository_name
}

locals {
  # Group containers by the service they belong to
  services_grouped = {
    for service_name in distinct([for s in var.services : s.service_name]) : service_name => {
      # Create a list of container objects for this service, including the original key.
      containers = [
        for key, container in var.services : merge(container, { original_key = key }) if container.service_name == service_name
      ]
    } 
  }
}

resource "aws_cloudwatch_log_group" "this" {
  for_each = local.services_grouped

  name              = "/ecs/sq-spec-portal-backend-${each.key}-log-group-staging"
  retention_in_days = var.log_retention_in_days

  tags = {
    Name      = "sq-spec-portal-backend-${each.key}-log-group-staging"
    ManagedBy = "Terraform"
  }
}

resource "aws_ecs_cluster" "this" {
  name = var.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }

  tags = {
    Name      = var.ecs_cluster_name
    ManagedBy = "Terraform"
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    capacity_provider = var.use_fargate_spot ? "FARGATE_SPOT" : "FARGATE"
    weight            = 1
    base              = 1
  }
}

# One task definition per Django service. Each task runs a single `app`
# container that receives traffic directly from the ALB target group.
resource "aws_ecs_task_definition" "this" {
  for_each = local.services_grouped

  family                   = "backend-service-${each.key}-staging"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = tostring(var.task_cpu)
  memory                   = tostring(var.task_memory)
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  container_definitions = jsonencode([
    for c in each.value.containers : merge(
      {
        name      = "backend-container-${c.original_key}-staging"
        image     = c.image != null ? c.image : "${data.aws_ecr_repository.app[c.original_key].repository_url}:${c.image_tag}"
        essential = c.essential
        cpu       = c.cpu != null ? c.cpu : var.app_cpu # Note: cpu and memory are now required in variables.tf
        memory    = c.memory != null ? c.memory : var.app_memory

        portMappings = [
          {
            containerPort = c.container_port
            hostPort      = c.container_port
            protocol      = "tcp"
          }
        ]

        environment = [
          for k, v in c.environment : {
            name  = k
            value = v
          }
        ]

        logConfiguration = {
          logDriver = "awslogs"
          options = {
            # Assuming one log group per service, but you could create one per container if needed
            awslogs-group         = aws_cloudwatch_log_group.this[each.key].name
            awslogs-region        = var.aws_region # us-east-1
            awslogs-stream-prefix = c.original_key
          }
        }
      },
      c.command != null ? { command = c.command } : {}
    )
  ])

  tags = {
    Name      = "backend-service-${each.key}-staging"
    ManagedBy = "Terraform"
  }
}

resource "aws_ecs_service" "this" {
  for_each = local.services_grouped

  name            = "backend-service-${each.key}-staging"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this[each.key].arn
  desired_count   = each.value.containers[0].desired_count

  capacity_provider_strategy {
    capacity_provider = var.use_fargate_spot ? "FARGATE_SPOT" : "FARGATE"
    weight            = 1
    base              = 1
  }

  network_configuration {
    subnets          = data.terraform_remote_state.vpc.outputs.public_subnet_ids
    security_groups  = [aws_security_group.service.id]
    assign_public_ip = var.assign_public_ip
  }

  dynamic "load_balancer" {
    for_each = { for c in each.value.containers : c.container_port => c }
    content {
      target_group_arn = aws_lb_target_group.this[load_balancer.value.original_key].arn
      container_name   = "backend-container-${load_balancer.value.original_key}-staging"
      container_port   = load_balancer.value.container_port
    }
  }

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  depends_on = [
    aws_lb_listener.http,
    aws_lb_listener_rule.path,
    aws_iam_role_policy_attachment.task_execution_role_policy,
  ]

  tags = {
    Name      = "backend-service-${each.key}-staging"
    ManagedBy = "Terraform"
  }
}
