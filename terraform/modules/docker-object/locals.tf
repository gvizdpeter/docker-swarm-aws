locals {
  remote_object_definition_file = var.remote_object_definition_file != null ? "${var.remote_object_definition_directory}/${var.remote_object_definition_file}" : "${var.remote_object_definition_directory}/docker_${var.object_type}_${var.object_name}"
  connection = {
    user         = var.connection_object.user
    private_key  = var.connection_object.private_key
    host         = var.connection_object.host
    bastion_host = var.connection_object.bastion_host != null ? var.connection_object.bastion_host : null
    bastion_user = var.connection_object.bastion_user != null ? var.connection_object.bastion_user : null
    timeout      = var.connection_object.timeout != null ? var.connection_object.timeout : "30s"
  }
}
