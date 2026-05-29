# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = var.vpc_id
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

# Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  name   = "backend-ec2-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ALB, Target Group, and Listener
resource "aws_lb" "backend_alb" {
  name               = "backend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnets
}

resource "aws_lb_target_group" "backend_tg" {
  name     = "backend-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}
# ECR Repository for your Docker images
resource "aws_ecr_repository" "backend" {
  name                 = "starttech-backend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true # <--- ADDED THIS to fix the "RepositoryNotEmpty" error

  image_scanning_configuration {
    scan_on_push = true # Senior requirement: Security scanning
  }
}

# IAM Role & Policies
resource "aws_iam_role" "ec2_role" {
  name = "EC2-ECR-ReadOnly-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "backend-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# Launch Template with Public IP and Docker Setup
resource "aws_launch_template" "backend_lt" {
  name_prefix   = "backend-lt-"
  image_id      = var.ami_id
  instance_type = "t2.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  network_interfaces {
    security_groups             = [aws_security_group.ec2_sg.id]
    associate_public_ip_address = true
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo yum update -y
              # Install Docker AND CloudWatch Agent
              sudo yum install -y docker amazon-cloudwatch-agent 
              sudo service docker start
              sudo systemctl enable docker
              sudo usermod -a -G docker ec2-user

              # --- CLOUDWATCH AGENT CONFIGURATION ---
              cat <<CONFIG > /opt/aws/amazon-cloudwatch-agent/bin/config.json
              {
                "logs": {
                  "logs_collected": {
                    "files": {
                      "collect_list": [
                        {
                          "file_path": "/var/log/backend-api.log",
                          "log_group_name": "/starttech/backend-logs",
                          "log_stream_name": "{instance_id}"
                        }
                      ]
                    }
                  }
                }
              }
              CONFIG

              # Start the CloudWatch Agent
              sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
              # --------------------------------------

              # Wait for Docker to be ready
              sleep 15
              while [ ! -S /var/run/docker.sock ]; do sleep 2; done

              # ECR Login and Deployment
              aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com

              docker pull ${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/starttech-backend:latest
              
              # Run container and redirect ALL logs to the file the CloudWatch Agent is watching
              docker run -d \
              --name backend \
              -p 8080:8080 \
              -e MONGO_URI="${var.mongo_uri}" \
              -e REDIS_URL="${var.redis_url}" \
              ${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/starttech-backend:latest > /var/log/backend-api.log 2>&1
              EOF
  )
}

# Auto Scaling Group in Public Subnets
resource "aws_autoscaling_group" "backend_asg" {
  name                      = "backend-asg"
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 1
  target_group_arns         = [aws_lb_target_group.backend_tg.arn]
  vpc_zone_identifier       = var.public_subnets
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.backend_lt.id
    version = aws_launch_template.backend_lt.latest_version
  }
}

# Auto Scaling Policy (Phase 1 Requirement)
resource "aws_autoscaling_policy" "cpu_scaling" {
  name                   = "target-cpu-80"
  autoscaling_group_name = aws_autoscaling_group.backend_asg.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80.0
  }
}
