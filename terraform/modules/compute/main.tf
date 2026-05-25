# Security Group for ALB (Allows Web Traffic)
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

# Application Load Balancer
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
  health_check { path = "/health" }
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

# Launch Template (Installs Docker & CloudWatch)
resource "aws_launch_template" "backend_lt" {
  name_prefix   = "backend-lt-"
  image_id      = var.ami_id # Use a standard Amazon Linux 2 AMI
  instance_type = "t2.micro"

  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker -y
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              # Install CloudWatch Agent
              sudo yum install amazon-cloudwatch-agent -y
              EOF
  )
}

# Auto Scaling Group
resource "aws_autoscaling_group" "backend_asg" {
  desired_capacity    = 2
  max_size            = 4
  min_size            = 1
  target_group_arns   = [aws_lb_target_group.backend_tg.arn]
  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.backend_lt.id
    version = "$Latest"
  }
}
