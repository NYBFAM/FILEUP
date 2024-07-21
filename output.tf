output "sftp_server_endpoint" {
  description = "The endpoint of the SFTP server"
  value       = aws_transfer_server.example.endpoint
}

output "sftp_server_id" {
  description = "The ID of the SFTP server"
  value       = aws_transfer_server.example.id
}

output "efs_file_system_id" {
  description = "The ID of the EFS file system"
  value       = aws_efs_file_system.example.id
}

output "sftp_user_name" {
  description = "The name of the SFTP user"
  value       = aws_transfer_user.example.user_name
}
