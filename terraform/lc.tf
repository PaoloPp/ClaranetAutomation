resource "aws_launch_configuration" "asg-lc" {
  name_prefix     = "WP-webapp"
  image_id        = data.aws_ami.ubuntu-2004
  instance_type   = "t2.small"
  user_data       = file("user-data.sh")
  security_groups = [aws_security_group.sg_asg]

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "ubuntu-2004" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}