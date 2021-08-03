resource "aws_efs_file_system" "main-efs" {
  creation_token   = "main-efs"
  performance_mode = "generalPurpose"
  tags = {
    Name = "main-efs"
  }
}

resource "aws_efs_mount_target" "main-efs-mount-target" {
  file_system_id  = aws_efs_file_system.main-efs.id
  subnet_id       = aws_subnet.main-private-subnet.id
  security_groups = [aws_security_group.main-efs-security-group.id]
}