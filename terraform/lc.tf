resource "aws_launch_configuration" "asg-lc" {
  name_prefix     = "WP-webapp"
  image_id        = data.aws_ami.amazon-linux.id
  instance_type   = "t2.micro"
  user_data       = file("user-data.sh")
  security_groups = [aws_security_group.sg_asg]

  lifecycle {
    create_before_destroy = true
  }
}
