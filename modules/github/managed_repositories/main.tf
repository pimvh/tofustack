locals {
  default_branch = "main"

  # set of default topics per type of repository
  topics_per_type = {
    "ansible-role" = ["ansible", "role", "molecule-tested"]
  }
}

resource "github_repository" "managed" {
  for_each    = var.github_repositories
  name        = each.key
  description = each.value.description
  # check whether we have default topics for this type
  # take into account that the value might be null (and we cannot lookup null in a map)
  topics        = distinct(concat(lookup(local.topics_per_type, each.value.type != null ? each.value.type : "", []), each.value.topics))
  has_downloads = false
  has_projects  = false
  has_issues    = true
  # only public repos needs discussions for now
  has_discussions        = lookup(each.value, "is_private", false) ? false : true
  has_wiki               = false
  vulnerability_alerts   = true
  visibility             = lookup(each.value, "is_private", false) ? "private" : "public"
  license_template       = lookup(each.value, "license", null)
  delete_branch_on_merge = true
  allow_squash_merge     = true
  allow_auto_merge       = true
  allow_merge_commit     = true
  allow_update_branch    = true
  auto_init              = true

  dynamic "security_and_analysis" {

    # only do this for public repos
    for_each = !lookup(each.value, "is_private", false) ? [1] : []
    content {

      # If a repository's visibility is public, advanced security is always enabled and cannot be changed,
      # so this setting cannot be supplied.
      # advanced_security {
      # }

      # If set to enabled, the repository's visibility must be public
      # goes for secret_scanning and secret_scanning_push_protection
      secret_scanning {
        status = "enabled"
      }

      secret_scanning_push_protection {
        status = "disabled"
      }

    }
  }
}

# main branch is created by auto_init (in managed above), so it cannot be created as
# a terraform resource
resource "github_branch_default" "main" {
  for_each   = var.github_repositories
  repository = github_repository.managed[each.key].name
  branch     = local.default_branch
}

#
# Specific things for Python repositories
#

module "python_repositories" {
  source = "../python_repository"
  providers = {
    github = github
  }

  # filter on molecule_images repositories
  for_each = { for repo, repo_attributes in var.github_repositories : repo => repo_attributes if lookup(repo_attributes, "type", null) == "python-package" }

  name            = each.key
  github_user     = var.github_user
  repository_id   = lookup(github_repository.managed, each.key, {"id" : "absent"}).id
  default_branch  = local.default_branch
  pypi_api_token  = each.value.secrets.pypi_api_token
}

#
# Specific things for Ansible repositories
#

module "ansible_role_repositories" {

  source = "../ansible_role_repository"
  providers = {
    github = github
  }

  # filter on ansible_role repositories
  for_each = { for repo, repo_attributes in var.github_repositories : repo => repo_attributes if lookup(repo_attributes, "type", null) == "ansible-role" }

  name                       = each.key
  github_user                = var.github_user
  repository_id              = lookup(github_repository.managed, each.key, {"id" : "absent"}).id
  default_branch             = local.default_branch
  ansible_galaxy_api_key     = each.value.secrets.ansible_galaxy_api_key
  molecule_testing_instances = lookup(each.value, "molecule_testing_instances", var.molecule_testing_instances)
  pinned_versions            = merge(var.pinned_versions, lookup(each.value, "pinned_versions", {}))
}

module "molecule_images_repository" {

  source = "../molecule_images_repository"
  providers = {
    github = github
  }

  # filter on molecule_images repositories
  for_each = { for repo, repo_attributes in var.github_repositories : repo => repo_attributes if lookup(repo_attributes, "type", null) == "molecule-images" }

  name                = each.key
  github_user         = var.github_user
  repository_id       = lookup(github_repository.managed, each.key, {"id" : "test"}).id
  default_branch      = local.default_branch
  quay_login_password = each.value.secrets.quay_login_password
}

module "ansible_stack_repository" {

  source = "../ansiblestack_repository"
  providers = {
    github = github
  }

  # filter on molecule_images repositories
  for_each = { for repo, repo_attributes in var.github_repositories : repo => repo_attributes if lookup(repo_attributes, "type", null) == "ansiblestack" }

  name            = each.key
  github_user     = var.github_user
  repository_id   = lookup(github_repository.managed, each.key, {"id" : "absent"}).id
  default_branch  = local.default_branch
  pinned_versions = var.pinned_versions
}

locals {
  branch_protections_by_repository = {
    for repo, value in merge(
    module.ansible_role_repositories,
    module.python_repositories,
    module.molecule_images_repository
  ) : repo => value.branch_protection
  }
}

module "managed_branch_protections" {
  for_each = local.branch_protections_by_repository

  source = "../managed_branch_protections"

  branch_protections = each.value
}

data "github_repositories" "all_user_github_repos" {
  query = "owner:${var.github_user.login}"
}

module "github_description" {
  source = "../description"
  providers = {
    null     = null
    external = external
  }

  github_repositories           = var.github_repositories
  all_found_github_repositories = data.github_repositories.all_user_github_repos
  non_default_attributes        = ["pinned_versions", "molecule_testing_instances"]

}
