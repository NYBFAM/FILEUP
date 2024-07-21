provider "aws" {
  region = "us-east-1"  # Adjust to your preferred region
}

# IAM Role for AWS Transfer Family Logging
resource "aws_iam_role" "transfer_logging" {
  name = "transfer_logging_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "transfer.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the logging policy to the IAM role
resource "aws_iam_role_policy_attachment" "transfer_logging_policy" {
  role       = aws_iam_role.transfer_logging.name
  policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSTransferLogging"
}

# AWS Transfer Family Server
resource "aws_transfer_server" "example" {
  endpoint_type = "PUBLIC"  # Use "VPC" for VPC endpoint configuration

  identity_provider_type = "SERVICE_MANAGED"
  logging_role = aws_iam_role.transfer_logging.arn
  protocols = ["SFTP"]

  tags = {
    Name = "example-sftp-server"
  }
}

# AWS Transfer Family User
resource "aws_transfer_user" "example" {
  server_id = aws_transfer_server.example.id
  user_name  = "example_user"
  role       = aws_iam_role.transfer_logging.arn  # Ensure the role is correctly specified

  home_directory = "/example"
  home_directory_type = "LOGICAL"

  // If 'ssh_public_keys' is not supported, consider using an alternative method to manage SSH keys.
  // Consult the latest AWS Transfer Family documentation for user key management.

  // Example without 'ssh_public_keys':
  // home_directory_mappings {
  //   entry = "/example"
  //   target = "/example_target"
  // }
}

# Security Group for EFS Mount Target
resource "aws_security_group" "efs_sg" {
  name_prefix = "efs-sg-"
  vpc_id      = "<vpc_id>"  # Replace with your VPC ID

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "efs-security-group"
  }
}

# Elastic File System (EFS)
resource "aws_efs_file_system" "example" {
  creation_token = "example-token"
  
  tags = {
    Name = "example-efs"
  }
}

resource "aws_efs_mount_target" "example" {
  file_system_id = aws_efs_file_system.example.id
  subnet_id = "<subnet_id>"  # Replace with your subnet ID
  security_groups = [aws_security_group.efs_sg.id]  # Reference to the security group
}

