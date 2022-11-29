data "external" "github_token" {
  # Github CLI does not have workflow permissions.
  program = ["./scripts/get_gh_token.sh"]
}

module "managed_github_keys" {
  providers = {
    github = github
  }

  source = "./modules/github/managed_keys"
}

module "managed_github_repositories" {
  providers = {
    github   = github,
    external = external,
    null     = null,
  }

  github_user         = data.github_user.current
  github_repositories = { for repo, repo_attrs in var.github_repositories : repo => merge(repo_attrs, { "secrets" : lookup(var.secrets, repo, {}) }) }
  pinned_versions     = var.pinned_versions

  source = "./modules/github/managed_repositories"
}

data "github_user" "current" {
  username = var.github_username
}
