output "object_defintion_content" {
  value = data.template_file.object_definition_file.rendered
}

output "object_name" {
  value = local.object_name
}