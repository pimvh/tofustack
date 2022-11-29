locals {
  # is interpolated so cannot be set in variables.tf
  default_path_prefix = var.path_prefix != null ? var.path_prefix : "${path.root}/files"
  managed_templates   = { for file_name, value in var.managed_templates : file_name => (lookup(value, "path", null) == null ? merge(value, { path = "${local.default_path_prefix}/${file_name}.tftpl" }) : value) }
}

resource "github_repository_file" "managed_templates" {
  for_each   = local.managed_templates
  repository = var.repository
  branch     = var.branch
  file       = each.key

  content = <<-EOT
  ${var.terraform_managed_tag}
  ${chomp(templatefile(each.value.path, lookup(each.value, "template_values", {})))}
  EOT

  # get commit message for element, default to just update file `filename`
  commit_message      = "terraform: ${lookup(each.value, "commit_message", "update file ${each.key}")}"
  overwrite_on_create = true
}

output "managed_templates" {
  value = local.managed_templates
}
