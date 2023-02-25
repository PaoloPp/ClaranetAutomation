resource "aws_launch_configuration" "asg-lc" {
  name_prefix     = "WP-webapp"
  image_id        = var.ubuntu-1604
  instance_type   = "t2.small"
  user_data       = file("user-data.sh")
  security_groups = [aws_security_group.sg_asg.id]

  lifecycle {
    create_before_destroy = true
  }
}