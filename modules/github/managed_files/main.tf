locals {
  default_path_prefix = var.path_prefix != null ? var.path_prefix : "${path.root}/files"
  managed_files       = { for filename, value in var.managed_files : filename => (lookup(value, "path", null) == null ? merge(value, { path = "${local.default_path_prefix}/${filename}" }) : value) }
}

resource "github_repository_file" "managed_files" {
  for_each   = local.managed_files
  repository = var.repository
  branch     = var.branch
  file       = each.key

  content = <<-EOT
  ${var.terraform_managed_tag}
  ${chomp(file(each.value.path))}
  EOT

  # get commit message for element, default to just update file `filename`
  commit_message      = "terraform: ${lookup(each.value, "commit_message", "update file ${each.key}")}"
  overwrite_on_create = true
}
