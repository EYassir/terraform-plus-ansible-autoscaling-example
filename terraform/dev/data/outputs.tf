output "mysql_host" {
    value = aws_db_instance.my_rds.endpoint
}

output "mysql_port" {
    value = aws_db_instance.my_rds.port
}