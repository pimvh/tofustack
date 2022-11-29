locals {

  # TODO move to higher level later
  # map of docker images organized by os -> version(s)
  instances = {
    ubuntu = [
      "jammy-jellyfish"
    ]

    debian = [
      "bookworm"
    ]
  }

  managed_templates = {
    ".github/workflows/build_and_push_molecule_images.yaml" = {
      template_values = {
        instances = local.instances
      }
    },
  }

}

module "managed_templates_in_molecule_images" {
  source            = "../managed_templates"
  repository        = var.name
  managed_templates = local.managed_templates
  path_prefix       = "${path.root}/files/"
  branch            = var.default_branch
}

resource "github_actions_secret" "quay_login_password" {
  count = var.quay_login_password != null ? 1 : 0

  repository      = var.name
  secret_name     = "QUAY_LOGIN"
  encrypted_value = var.quay_login_password
}
