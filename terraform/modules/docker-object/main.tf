data "template_file" "object_definition_file" {
  template = file(var.object_definition_file)
  vars     = var.object_defintion_variables
}

resource "null_resource" "docker_object_definition_copy" {
  depends_on = [
    data.template_file.object_definition_file
  ]

  triggers = {
    object_definition_template = filemd5(var.object_definition_file)
    object_defintion_variables = local.object_defintion_variables_string
  }

  connection {
    user         = local.connection.user
    private_key  = local.connection.private_key
    host         = local.connection.host
    bastion_host = local.connection.bastion_host
    bastion_user = local.connection.bastion_user
    timeout      = local.connection.timeout
  }

  provisioner "file" {
    content     = data.template_file.object_definition_file.rendered
    destination = local.remote_object_definition_file
  }
}

resource "null_resource" "docker_stack_creation" {
  count = var.object_type == "stack" ? 1 : 0

  depends_on = [
    data.template_file.object_definition_file,
    null_resource.docker_object_definition_copy
  ]

  triggers = {
    object_definition_template = filemd5(var.object_definition_file)
    object_defintion_variables = local.object_defintion_variables_string
  }

  connection {
    user         = local.connection.user
    private_key  = local.connection.private_key
    host         = local.connection.host
    bastion_host = local.connection.bastion_host
    bastion_user = local.connection.bastion_user
    timeout      = local.connection.timeout
  }

  provisioner "remote-exec" {
    inline = [
      "docker stack deploy -c ${local.remote_object_definition_file} ${local.object_name}"
    ]
  }
}

resource "null_resource" "docker_config_creation" {
  count = var.object_type == "config" ? 1 : 0

  depends_on = [
    data.template_file.object_definition_file,
    null_resource.docker_object_definition_copy
  ]

  triggers = {
    object_definition_template = filemd5(var.object_definition_file)
    object_defintion_variables = local.object_defintion_variables_string
  }

  connection {
    user         = local.connection.user
    private_key  = local.connection.private_key
    host         = local.connection.host
    bastion_host = local.connection.bastion_host
    bastion_user = local.connection.bastion_user
    timeout      = local.connection.timeout
  }

  provisioner "remote-exec" {
    inline = [
      "docker config create ${local.object_name} ${local.remote_object_definition_file}"
    ]
  }
}

resource "null_resource" "docker_secret_creation" {
  count = var.object_type == "secret" ? 1 : 0

  depends_on = [
    data.template_file.object_definition_file,
    null_resource.docker_object_definition_copy
  ]

  triggers = {
    object_definition_template = filemd5(var.object_definition_file)
    object_defintion_variables = local.object_defintion_variables_string
  }

  connection {
    user         = local.connection.user
    private_key  = local.connection.private_key
    host         = local.connection.host
    bastion_host = local.connection.bastion_host
    bastion_user = local.connection.bastion_user
    timeout      = local.connection.timeout
  }

  provisioner "remote-exec" {
    inline = [
      "docker secret create ${local.object_name} ${local.remote_object_definition_file}",
      "rm ${local.remote_object_definition_file}"
    ]
  }
}