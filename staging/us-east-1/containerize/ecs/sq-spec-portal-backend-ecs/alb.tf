resource "aws_security_group" "alb" {
  name        = "backend-alb-sg-staging"
  description = "Allow public HTTP traffic to the ALB gateway."
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "backend-alb-sg-staging"
    ManagedBy = "Terraform"
  }
}

resource "aws_security_group" "service" {
  name        = "backend-svc-sg-staging"
  description = "Allow the ALB to reach the app container on each service port."
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # Create a flattened map of all container ports across all services
  dynamic "ingress" {
    for_each = var.services
    content {
      description     = "App container port ${ingress.value.container_port} from ALB for ${ingress.key}"
      from_port       = ingress.value.container_port
      to_port         = ingress.value.container_port
      protocol        = "tcp"
      security_groups = [aws_security_group.alb.id]
    }
  }

  egress {
    description = "Allow outbound to PostgreSQL DB"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description     = "Allow outbound to ECR and S3 for image pulls"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "backend-svc-sg-staging"
    ManagedBy = "Terraform"
  }
}

resource "aws_lb" "this" {
  name               = "backend-alb-staging"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = data.terraform_remote_state.vpc.outputs.public_subnet_ids

  # access_logs {
  #   bucket  = var.alb_log_bucket_name
  #   enabled = true
  # }

  tags = {
    Name      = "backend-alb-staging"
    ManagedBy = "Terraform"
  }
}

resource "aws_lb_target_group" "this" {
  for_each = var.services

  name        = substr("backend-${each.key}-tg-staging", 0, 32)
  port        = each.value.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  health_check {
    path                = lookup(each.value, "health_check_path", "/health")
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name      = "backend-${each.key}-tg-staging"
    ManagedBy = "Terraform"
  }
}

# Unmatched paths return 404 instead of hitting a default backend.
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "path" {
  for_each = var.services

  listener_arn = aws_lb_listener.http.arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.key].arn
  }

  condition {
    path_pattern {
      values = each.value.path_patterns
    }
  }

  tags = {
    Name      = "backend-${each.key}-rule-staging"
    ManagedBy = "Terraform"
  }
}
