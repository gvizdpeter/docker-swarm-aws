output "object_defintion_content" {
  value = data.template_file.object_definition_file.rendered
}

output "object_name" {
  value = var.object_type == "stack" ? null_resource.docker_stack_creation[0].triggers.object_name : null_resource.docker_config_creation[0].triggers.object_name
}