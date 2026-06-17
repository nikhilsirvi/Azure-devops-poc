terraform {
  backend "s3" {}
}

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
          awslogs-region        = "ap-southeast-1"
          awslogs-stream-prefix = "ecs"
        }
      }
      # ---------------------------
      # NORMAL ENV VARIABLES (SSM)
      # ---------------------------
      environment = [
        {
          name  = "MAIN_SERVER_URL"
          value = "http://localhost:8000"
        },
        {
          name  = "RIG_NAME"
          value = "panacea_rig_01"
        }
      ]

      # ---------------------------
      # SECRETS (SSM + Secrets Manager)
      # ---------------------------
      secrets = [
        {
          name      = "DATABASE_URL"
          valueFrom = "${var.secret_arn}:DATABASE_URL::"
        },
        {
          name      = "SECRET_KEY"
          valueFrom = "${var.secret_arn}:SECRET_KEY::"
        },
        {
          name      = "COGNITO_CLIENT_SECRET"
          valueFrom = "${var.secret_arn}:COGNITO_CLIENT_SECRET::"
        },
        {
          name      = "CORS_ORIGINS"
          valueFrom = "${var.secret_arn}:CORS_ORIGINS::"
        },

        # SSM PARAMETERS
        {
          name      = "AUTH_PROVIDER"
          valueFrom = "arn:aws:ssm:${var.region}:${var.account_id}:parameter/backend/dev/AUTH_PROVIDER"
        },
        {
          name      = "COGNITO_USER_POOL_ID"
          valueFrom = "arn:aws:ssm:${var.region}:${var.account_id}:parameter/backend/dev/COGNITO_USER_POOL_ID"
        },
        {
          name      = "COGNITO_CLIENT_ID"
          valueFrom = "arn:aws:ssm:${var.region}:${var.account_id}:parameter/backend/dev/COGNITO_CLIENT_ID"
        },
        {
          name      = "COGNITO_REGION"
          valueFrom = "arn:aws:ssm:${var.region}:${var.account_id}:parameter/backend/dev/COGNITO_REGION"
        },
        {
          name      = "TEMP_TOKEN_EXPIRE_MINUTES"
          valueFrom = "arn:aws:ssm:${var.region}:${var.account_id}:parameter/backend/dev/TEMP_TOKEN_EXPIRE_MINUTES"
        },
        {
          name      = "SYNC_INTERVAL_SECONDS"
          valueFrom = "arn:aws:ssm:${var.region}:${var.account_id}:parameter/backend/dev/SYNC_INTERVAL_SECONDS"
        },
        {
          name      = "CONFIG_REFRESH_INTERVAL_SECONDS"
          valueFrom = "arn:aws:ssm:${var.region}:${var.account_id}:parameter/backend/dev/CONFIG_REFRESH_INTERVAL_SECONDS"
        },
        {
          name      = "REQUEST_TIMEOUT"
          valueFrom = "arn:aws:ssm:${var.region}:${var.account_id}:parameter/backend/dev/REQUEST_TIMEOUT"
        },
        {
          name      = "RIG_SERVER_PORT"
          valueFrom = "arn:aws:ssm:${var.region}:${var.account_id}:parameter/backend/dev/RIG_SERVER_PORT"
        }
      ]
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