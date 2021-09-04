data "template_file" "object_definition_file" {
  template = file(var.object_definition_file)
  vars     = var.object_defintion_variables
}

resource "null_resource" "docker_object_definition_copy" {
  triggers = {
    object_definition_template    = filemd5(var.object_definition_file)
    object_defintion_variables    = md5(jsonencode(var.object_defintion_variables))
    user                          = local.connection.user
    private_key                   = local.connection.private_key
    host                          = local.connection.host
    bastion_host                  = local.connection.bastion_host
    bastion_user                  = local.connection.bastion_user
    timeout                       = local.connection.timeout
    remote_object_definition_file = local.remote_object_definition_file
  }

  connection {
    user         = self.triggers.user
    private_key  = self.triggers.private_key
    host         = self.triggers.host
    bastion_host = self.triggers.bastion_host
    bastion_user = self.triggers.bastion_user
    timeout      = self.triggers.timeout
  }

  provisioner "file" {
    content     = data.template_file.object_definition_file.rendered
    destination = self.triggers.remote_object_definition_file
  }

  provisioner "remote-exec" {
    when = destroy
    inline = [
      "rm ${self.triggers.remote_object_definition_file}"
    ]
  }
}

resource "null_resource" "docker_stack_creation" {
  count = var.object_type == "stack" ? 1 : 0

  depends_on = [
    null_resource.docker_object_definition_copy
  ]

  triggers = {
    object_definition_template = filemd5(var.object_definition_file)
    object_defintion_variables = md5(jsonencode(var.object_defintion_variables))
    user                       = local.connection.user
    private_key                = local.connection.private_key
    host                       = local.connection.host
    bastion_host               = local.connection.bastion_host
    bastion_user               = local.connection.bastion_user
    timeout                    = local.connection.timeout
    object_name                = var.object_name
  }

  connection {
    user         = self.triggers.user
    private_key  = self.triggers.private_key
    host         = self.triggers.host
    bastion_host = self.triggers.bastion_host
    bastion_user = self.triggers.bastion_user
    timeout      = self.triggers.timeout
  }

  provisioner "remote-exec" {
    inline = [
      "docker stack deploy -c ${local.remote_object_definition_file} ${self.triggers.object_name}"
    ]
  }

  provisioner "remote-exec" {
    when = destroy
    inline = [
      "docker stack rm ${self.triggers.object_name}"
    ]
  }
}

resource "null_resource" "docker_config_creation" {
  count = var.object_type == "config" ? 1 : 0

  depends_on = [
    null_resource.docker_object_definition_copy
  ]

  triggers = {
    object_definition_template = filemd5(var.object_definition_file)
    object_defintion_variables = md5(jsonencode(var.object_defintion_variables))
    user                       = local.connection.user
    private_key                = local.connection.private_key
    host                       = local.connection.host
    bastion_host               = local.connection.bastion_host
    bastion_user               = local.connection.bastion_user
    timeout                    = local.connection.timeout
    object_name                = var.object_name
  }

  connection {
    user         = self.triggers.user
    private_key  = self.triggers.private_key
    host         = self.triggers.host
    bastion_host = self.triggers.bastion_host
    bastion_user = self.triggers.bastion_user
    timeout      = self.triggers.timeout
  }

  provisioner "remote-exec" {
    inline = [
      "docker config create ${self.triggers.object_name} ${local.remote_object_definition_file}"
    ]
  }

  provisioner "remote-exec" {
    when = destroy
    inline = [
      "docker config rm ${self.triggers.object_name}"
    ]
  }
}