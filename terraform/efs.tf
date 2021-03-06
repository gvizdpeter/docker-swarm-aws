resource "aws_efs_file_system" "main_efs" {
  creation_token   = "main-efs"
  performance_mode = "generalPurpose"
  tags = {
    Name = "main-efs"
  }
}

resource "aws_efs_mount_target" "main_efs_mount_target" {
  file_system_id  = aws_efs_file_system.main_efs.id
  subnet_id       = module.main_vpc.private_subnets[0]
  security_groups = [aws_security_group.main_efs_security_group.id]
}