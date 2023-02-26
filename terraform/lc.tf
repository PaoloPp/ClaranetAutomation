resource "aws_launch_configuration" "asg-lc" {
  image_id        = "ami-02f0341ac93c96375" #Ubuntu 18.04 LTS AMI ID
  instance_type   = "t3.micro"
  user_data       = file("user-data.sh")
  security_groups = [aws_security_group.sg_asg.id]

  lifecycle {
    create_before_destroy = true
  }

}