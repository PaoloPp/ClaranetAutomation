resource "aws_efs_file_system" "wp_efs" {
  creation_token = "wp_efs"
  tags = {
    Name = "WP_efs"
  }
}

resource "aws_efs_mount_target" "mount" {
  count           = length(module.vpc.private_subnets)
  file_system_id  = aws_efs_file_system.wp_efs.id
  subnet_id       = module.vpc.private_subnets[count.index]
  security_groups = [aws_security_group.sg_asg.id]
}




