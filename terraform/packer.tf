resource "null_resource" "packer_instance" {
  triggers = {
    default_ami_id = var.DEFAULT_AMI_ID
  }

  provisioner "local-exec" {
    command = "packer build -machine-readable packer/packer-instance.json | tee packer/packer.log | grep -Eo 'ami-[0-9a-z]+' | tail -1 | head -c -1 > ${path.cwd}/${var.AWS_AMI_ID_FILE}"

    environment = {
      VPC_ID    = module.main_vpc.vpc_id
      SUBNET_ID = module.main_vpc.public_subnets[0]
    }
  }

  depends_on = [
    module.main_vpc
  ]
}

data "local_file" "packer_ami_file" {
  filename = "${path.cwd}/${var.AWS_AMI_ID_FILE}"

  depends_on = [
    null_resource.packer_instance
  ]
}