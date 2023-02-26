//output "mysql_host" {
//  value = aws_db_instance.example.address
//}
//
//output "mysql_port" {
//  value = aws_db_instance.example.port
//}
//
//output "mysql_username" {
//  value = aws_db_instance.example.username
//}
//
//output "mysql_password" {
//  value     = aws_db_instance.example.password
//  sensitive = true
//}
//
//output "mysql_database_name" {
//  value = aws_db_instance.example.name
//}

output "efs_mount" {
  value = aws_efs_file_system.wp_efs.dns_name
}