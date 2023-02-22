resource "aws_lb" "web_alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = aws_security_group.sg_alb.id

  subnets = module.vpc.public_subnets

  enable_deletion_protection = true
  tags = {
    Terraform   = "true"
    Environment = "test"
  }
}