output "load_balancer_arn" {
  value = aws_lb.loadbalancer.arn
}

output "load_balancer_name" {
  value = aws_lb.loadbalancer.name
}

output "autoscaling_group_arn" {
  value = aws_autoscaling_group.asg.arn
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.asg.name
}

output "target_group_arn" {
  value = aws_lb_target_group.targetgroup.arn
}

output "target_group_name" {
  value = aws_lb_target_group.targetgroup.name
}

output "launch_template_name" {
  value = aws_launch_template.launch_template.name
}

output "cloud_watch_alarm_name" {
  value = aws_cloudwatch_metric_alarm.cpu_high
}

output "allow_web_security_group_arn" {
  value = aws_security_group.allow_web.arn
}

output "instance_profile_arn" {
  value = aws_iam_instance_profile.instance_profile.arn
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.instance_profile.name
}
