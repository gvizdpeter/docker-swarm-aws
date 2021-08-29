locals {
    remote_object_definition_file = var.remote_object_definition_file != null ? "${var.remote_object_definition_directory}/${var.remote_object_definition_file}" : "${var.remote_object_definition_directory}/docker-${var.object_type}-${var.object_name}"
}