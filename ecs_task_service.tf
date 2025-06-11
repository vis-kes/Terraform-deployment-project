resource "aws_ecs_task_definition" "app" {
  family                   = "simple-time-service"           # Updated family name
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "simple-time-service"   # Updated container name
      image     = var.app_image           # This should point to the new simple-time-service image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000            # Updated to container port 3000
          hostPort      = 3000            # Host port also set to 3000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = "simple-time-service-service"    # Updated service name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2
  launch_type     = "EC2"

  network_configuration {
    subnets          = [aws_subnet.private[0].id, aws_subnet.private[1].id]
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "simple-time-service"   # Updated container name
    container_port   = 3000                     # Updated to 3000
  }

  depends_on = [aws_autoscaling_group.ecs]
}

