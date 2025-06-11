resource "aws_lb" "app" {
  name               = "simple-time-service-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public[0].id, aws_subnet.public[1].id]
  tags = {
    Name = "simple-time-service-alb"
  }
}

resource "aws_lb_target_group" "app" {
  name        = "simple-time-service-tg"
  port        = 3000               # Updated to 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"               # ECS tasks are registered as IPs

  health_check {
    path                = "/health"  # Adjust health check path if needed
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80                   # Front-end listener still on port 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

