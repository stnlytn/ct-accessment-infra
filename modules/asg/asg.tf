resource "aws_security_group" "allow_web" {
  name        = "allow_web_sg"
  description = "Allow web inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }
}

resource "aws_lb" "loadbalancer" {
  name               = "${var.project_name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_web.id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_target_group" "targetgroup" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.targetgroup.arn
  }
}

resource "aws_launch_template" "launch_template" {
  name_prefix   = var.project_name
  image_id      = var.image_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.allow_web.id]
  }

  #   user_data = base64encode("...") # your startup script here

  lifecycle {
    create_before_destroy = true
  }

  iam_instance_profile {
    name = var.instance_profile_name
  }
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity          = 1
  max_size                  = 5
  min_size                  = 1
  health_check_type         = "ELB"
  health_check_grace_period = 300
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [desired_capacity]
  }

  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [aws_lb_target_group.targetgroup.arn]
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 2
  cooldown               = 300
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu-usage-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "65"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_actions     = [aws_autoscaling_policy.scale_up.arn]
  alarm_description = "This metric triggers when CPU usage is above 50% for 2 consecutive periods of 120 seconds"
}
