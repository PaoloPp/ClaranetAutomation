resource "aws_autoscaling_group" "web-asg" {
  name                 = "web-asg"
  min_size             = 1
  max_size             = 5
  vpc_zone_identifier  = module.vpc.private_subnets
  launch_configuration = aws_launch_configuration.asg-lc
}

resource "aws_autoscaling_policy" "web-asg-up" {
  name                   = "web-asg-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web-asg.name
}

resource "aws_autoscaling_policy" "web-asg-down" {
  name                   = "web-asg-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web-asg.name

}

resource "aws_cloudwatch_metric_alarm" "web-cpu-alarm-up" {
  alarm_name          = "web-cpu-up-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    autoscaling_group_name = aws_autoscaling_group.web-asg.name
  }

  alarm_description = "Monitoring metric for CPU utilization"
  alarm_actions     = aws_autoscaling_policy.web-asg-up.arn

}

resource "aws_cloudwatch_metric_alarm" "web-cpu-alarm-down" {
  alarm_name          = "web-cpu-down-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    autoscaling_group_name = aws_autoscaling_group.web-asg.name
  }

  alarm_description = "Monitoring metric for CPU utilization"
  alarm_actions     = aws_autoscaling_policy.web-asg-down.arn

}