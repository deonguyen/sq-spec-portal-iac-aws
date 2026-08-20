data "aws_caller_identity" "current" {}

data "aws_ecr_repository" "app" {
  for_each = { for k, s in var.services : k => s if s.ecr_repository_name != null }
  name     = each.value.ecr_repository_name
}

resource "aws_cloudwatch_log_group" "this" {
  for_each = var.services

  name              = "/ecs/${var.service_name}-${each.key}"
  retention_in_days = var.log_retention_in_days

  tags = {
    Name      = "${var.service_name}-${each.key}"
    ManagedBy = "Terraform"
  }
}

resource "aws_ecs_cluster" "this" {
  name = var.service_name

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }

  tags = {
    Name      = var.service_name
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
  for_each = var.services

  family                   = "${var.service_name}-${each.key}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  container_definitions = jsonencode([
    merge(
      {
        name      = "${var.service_name}-${each.key}"
        image     = each.value.image != null ? each.value.image : "${data.aws_ecr_repository.app[each.key].repository_url}:${each.value.image_tag}"
        essential = true
        cpu       = var.app_cpu
        memory    = var.app_memory

        portMappings = [
          {
            containerPort = each.value.container_port
            hostPort      = each.value.container_port
            protocol      = "tcp"
          }
        ]

        environment = [
          for k, v in each.value.environment : {
            name  = k
            value = v
          }
        ]

        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = aws_cloudwatch_log_group.this[each.key].name
            awslogs-region        = var.aws_region
            awslogs-stream-prefix = "app"
          }
        }
      },
      each.value.command != null ? { command = each.value.command } : {}
    )
  ])

  tags = {
    Name      = "${var.service_name}-${each.key}"
    ManagedBy = "Terraform"
  }
}

resource "aws_ecs_service" "this" {
  for_each = var.services

  name            = "${var.service_name}-${each.key}"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this[each.key].arn
  desired_count   = each.value.desired_count

  capacity_provider_strategy {
    capacity_provider = var.use_fargate_spot ? "FARGATE_SPOT" : "FARGATE"
    weight            = 1
    base              = 1
  }

  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.service.id]
    assign_public_ip = var.assign_public_ip
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this[each.key].arn
    container_name   = "${var.service_name}-${each.key}"
    container_port   = each.value.container_port
  }

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  depends_on = [
    aws_lb_listener.http,
    aws_lb_listener_rule.path,
    aws_iam_role_policy_attachment.task_execution_role_policy,
  ]

  tags = {
    Name      = "${var.service_name}-${each.key}"
    ManagedBy = "Terraform"
  }
}
