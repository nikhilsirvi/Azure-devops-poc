

resource "aws_ecs_task_definition" "this" {
  family                   = var.name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "256"
  memory = "512"

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name  = "app"
      image = var.image

      portMappings = [
        {
          name          = "app"
          containerPort = 8000
          protocol      = "tcp"
        }
      ]

      essential = true

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/dev-backend"
          awslogs-region        = "ca-central-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = var.name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  enable_execute_command = true

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [var.ecs_sg]
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "app"
    container_port   = 8000
  }

  service_connect_configuration {
    enabled   = true
    namespace = var.namespace

    service {
      port_name      = "app"
      discovery_name = var.name

      client_alias {
        port     = 8000
        dns_name = var.name
      }
    }
  }

  depends_on = [var.listener_arn]
}