resource "aws_security_group" "alb" {
  name        = "${var.service_name}-alb-sg"
  description = "Allow public HTTP traffic to the ALB gateway."
  vpc_id      = module.vpc.vpc_id

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
    Name      = "${var.service_name}-alb-sg"
    ManagedBy = "Terraform"
  }
}

resource "aws_security_group" "service" {
  name        = "${var.service_name}-svc-sg"
  description = "Allow the ALB to reach the app container on each service port."
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = { for k, s in var.services : tostring(s.container_port) => s.container_port... }
    content {
      description     = "App container port ${ingress.key} from ALB"
      from_port       = tonumber(ingress.key)
      to_port         = tonumber(ingress.key)
      protocol        = "tcp"
      security_groups = [aws_security_group.alb.id]
    }
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.service_name}-svc-sg"
    ManagedBy = "Terraform"
  }
}

resource "aws_lb" "this" {
  name               = substr(var.service_name, 0, 32)
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = module.vpc.public_subnets

  access_logs {
    bucket  = var.alb_log_bucket_name
    enabled = true
  }

  tags = {
    Name      = var.service_name
    ManagedBy = "Terraform"
  }
}

resource "aws_lb_target_group" "this" {
  for_each = var.services

  name        = substr("${var.service_name}-${each.key}-tg", 0, 32)
  port        = each.value.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    path                = lookup(each.value, "health_check_path", var.health_check_path)
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name      = "${var.service_name}-${each.key}-tg"
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
    Name      = "${var.service_name}-${each.key}-rule"
    ManagedBy = "Terraform"
  }
}
