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

  depends_on = [
    aws_autoscaling_group.web-asg
  ]

  provisioner "local-exec" {
    command = "aws ec2 describe-instances --instance-ids $ID --region eu-west-1 --query Reservations[].Instances[].PrivateIpAddress --output text > first_ip"
  }

}

data "local_file" "foo" {
  filename = "./first_ip"
  depends_on = [
    aws_efs_mount_target.mount
  ]
}

resource "null_resource" "configure_nfs" {
  depends_on = [aws_efs_mount_target.mount]
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.rsa_keys.private_key_pem
    host        = data.local_file.foo.content
  }
  provisioner "remote-exec" {
    inline = [
      "cd /tmp",
      "wget https://wordpress.org/latest.tar.gz",
      "tar -xvzf latest.tar.gz",
      "sudo mv wordpress /var/www/html/",
      "sudo chown -R www-data:www-data /var/www/html/wordpress/",
      "sudo chmod -R 755 /var/www/html/wordpress/",
      "cd /var/www/html/wordpress/",
      "cp wp-config-sample.php wp-config.php",
      "sudo systemctl restart apache2",
      "rm /tmp/latest.tar.gz"
    ]
  }
}


