output "TestInstance1_pub_ip" {
    value = "${aws_instance.TestInstance1.0.public_ip}"
}

output "TestInstance1_id" {
    value = "${aws_instance.TestInstance1.0.id}"
}

output "hostname" {
  value       = aws_db_instance.postgresql.address
  description = "Public DNS name of database instance"
}

output "id" {
  value       = aws_db_instance.postgresql.id
  description = "The database instance ID"
}

output "port" {
  value       = aws_db_instance.postgresql.port
  description = "Port of database instance"
}

output "endpoint" {
  value       = aws_db_instance.postgresql.endpoint
  description = "Public DNS name and port separated by a colon"
}


