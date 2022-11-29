locals {
  ansible_path_prefix = "${path.root}/files/ansible/"

  managed_files = {
    # TODO: is currently different, figure out why
    # ".yamllint" = {
    # },

    ".ansible-lint" = {
    },
  }

  test_requirements = [
    "ansible",
    "ansible-core",
    "ansible-lint",
    "molecule",
    "molecule-plugins[docker]",
    "pytest-testinfra"
  ]


  managed_templates = {
    "test_requirements.txt" = {
      path = "${path.root}/files/python/requirements.txt.tftpl"

      template_values = {
        requirements = { for package_name, package_attributes in var.pinned_versions : package_name => package_attributes if contains(local.test_requirements, package_name) }
      }
    },
  }
}

module "managed_files_in_ansiblestack" {
  source        = "../managed_files"
  repository    = var.name
  managed_files = local.managed_files
  path_prefix   = local.ansible_path_prefix
  branch        = var.default_branch
}

module "managed_templates_in_ansiblestack" {
  source            = "../managed_templates"
  repository        = var.name
  managed_templates = local.managed_templates
  path_prefix       = local.ansible_path_prefix
  branch            = var.default_branch
}

# TODO: cannot be enabled for private repositories
# resource "github_branch_protection" "main_protection" {
#   repository_id = var.repository_id
#   pattern       = var.default_branch
#
#   allows_deletions                = false
#   required_linear_history         = true
#   require_conversation_resolution = true
# }
