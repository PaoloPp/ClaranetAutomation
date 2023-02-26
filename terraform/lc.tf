resource "aws_launch_configuration" "asg-lc" {
  image_id        = "ami-02f0341ac93c96375" #Ubuntu 18.04 LTS AMI ID
  instance_type   = "t3.micro"
  user_data       = base64encode(templatefile("user-data.sh", { efs_mount = aws_efs_file_system.wp_efs.dns_name, db_host = module.db.db_instance_address, db_user = module.db.db_instance_username, db_pass = var.db_pass, db_name = module.db.db_instance_name }))
  security_groups = [aws_security_group.sg_asg.id]

  lifecycle {
    create_before_destroy = true
  }

}