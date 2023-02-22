resource "aws_lb_target_group" "asg-tg-80" {
  name     = "asg-tg-80"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

}

resource "aws_lb_target_group" "asg-tg-443" {
  name     = "asg-tg-443"
  port     = 443
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

}

resource "aws_autoscaling_attachment" "asg-attachment-80" {
  autoscaling_group_name = aws_autoscaling_group.web-asg
  alb_target_group_arn   = aws_lb_target_group.asg-tg-80
}

resource "aws_autoscaling_attachment" "asg-attachment-443" {
  autoscaling_group_name = aws_autoscaling_group.web-asg
  alb_target_group_arn   = aws_lb_target_group.asg-tg-443
}