resource "null_resource" "packer_instance" {
  triggers = {
    default_ami_id = var.DEFAULT_AMI_ID
  }

  provisioner "local-exec" {
    command = "packer build -machine-readable packer/packer-instance.json | tee packer/packer.log | grep -Eo 'ami-[0-9a-z]+' | tail -1 | head -c -1 > ${path.cwd}/${var.AWS_AMI_ID_FILE}"

    environment = {
      VPC_ID    = aws_vpc.main_vpc.id
      SUBNET_ID = aws_subnet.main_public_subnet.id
    }
  }

  depends_on = [
    aws_route_table_association.main_public_route_table_assoc
  ]
}

data "local_file" "packer_ami_file" {
  filename = "${path.cwd}/${var.AWS_AMI_ID_FILE}"

  depends_on = [
    null_resource.packer_instance
  ]
}