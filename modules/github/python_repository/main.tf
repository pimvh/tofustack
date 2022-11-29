locals {
  managed_files = {
    ".github/workflows/release.yaml" = {
      path = "${path.root}/files/.github/workflows/publish_python_package_with_nix.yaml"
    },
  }
}

module "managed_files_in_python_repository" {
  source        = "../managed_files"
  repository    = var.name
  managed_files = local.managed_files
  branch        = var.default_branch
}

resource "github_actions_secret" "pypi_api_token" {
  count = var.pypi_api_token != null ? 1 : 0

  repository      = var.name
  secret_name     = "PIPY_API_TOKEN"
  encrypted_value = var.pypi_api_token
}
