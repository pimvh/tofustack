locals {
  ansible_path_prefix = "${path.module}/files/"

  managed_files = {

    ".yamllint" = {
      path = "${path.root}/files/ansible/.yamllint"
    },

    ".ansible-lint" = {
      path = "${path.root}/files/ansible/.ansible-lint"
    },


    ".github/workflows/publish.yaml" = {
      path = "${path.root}/files/.github/workflows/publish.yaml"
    },

    ".gitignore" = {
    }

  }

  # docker image tag of the default test
  default_instance = "ubuntu-jammy-jellyfish"

  # make all status checks required (in matrix format)
  required_status_checks = concat(["lint"],
    flatten([for os, versions in var.molecule_testing_instances : [for version in versions : "molecule (${os}, ${version})"]
  ]))

  test_requirements = [
    "ansible",
    "ansible-core",
    "ansible-lint",
    "molecule",
    "molecule-plugins[docker]",
    "pytest-testinfra"
  ]


  deploy_requirements = [
    "ansible",
  ]

  managed_templates = {
    "molecule/default/converge.yml" = {
      template_values = {
        role_name = var.name
      }
    },

    "molecule/default/molecule.yml" = {
      template_values = {
        instance_names   = flatten([for os, versions in var.molecule_testing_instances : [for version in versions : "${os}-${version}"]])
        default_instance = local.default_instance
        default_image_id = "molecule-${local.default_instance}"
      }
    },

    ".github/workflows/test.yaml" = {
      path = "${path.root}/files/.github/workflows/test.yaml.tftpl"

      template_values = {
        instances = var.molecule_testing_instances
      }
    },

    "test_requirements.txt" = {
      path = "${path.root}/files/python/requirements.txt.tftpl"

      template_values = {
        requirements = { for package_name, package_attributes in var.pinned_versions : package_name => package_attributes if contains(local.test_requirements, package_name) }
      }
    },

    "deploy_requirements.txt" = {
      path = "${path.root}/files/python/requirements.txt.tftpl"

      template_values = {
        requirements = { for package_name, package_attributes in var.pinned_versions : package_name => package_attributes if contains(local.deploy_requirements, package_name) }
      }
    },
  }
}

module "managed_files_in_ansible" {
  source        = "../managed_files"
  repository    = var.name
  managed_files = local.managed_files
  path_prefix   = local.ansible_path_prefix
  branch        = var.default_branch
}

module "managed_templates_in_ansible" {
  source            = "../managed_templates"
  repository        = var.name
  managed_templates = local.managed_templates
  path_prefix       = local.ansible_path_prefix
  branch            = var.default_branch
}

resource "github_actions_secret" "ansible_galaxy_api_key" {
  count = var.ansible_galaxy_api_key != null ? 1 : 0

  repository      = var.name
  secret_name     = "ANSIBLE_GALAXY_API_KEY"
  encrypted_value = var.ansible_galaxy_api_key
}
