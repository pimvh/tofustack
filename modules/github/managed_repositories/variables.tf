variable "github_user" {
  type = object({
    id = string
    node_id =string
    login = string
    avatar_url = string
    gravatar_id = string
    site_admin = bool
    name = string
    company = string
    blog = string
    location = string
    email = string
    gpg_keys = list(string)
    ssh_keys = list(string)
    bio = string
    public_repos = number
    public_gists = number
    followers = number
    following = number
    created_at = string
  })
  description = "data about a user on Github"
  nullable    = false
}

variable "github_repositories" {
  type = map(object({
    description                = string
    topics                     = list(string)
    is_private                 = bool
    license                    = string
    type                       = string
    molecule_testing_instances = map(list(string))
    secrets = object({
      ansible_galaxy_api_key = optional(string, null)
      quay_login_password    = optional(string, null)
      pypi_api_token         = optional(string, null)
    })
    pinned_versions = map(object({
      version = string
      comment = string
    }))
  }))

  description = "Mapping of Github repositories present in the namespace"
  nullable    = false
}

variable "pinned_versions" {
  type = map(object({
    version = string
    comment = string
  }))
  description = "versions pinned for packages used in repos"
}

variable "molecule_testing_instances" {
  type        = map(list(string))
  description = "molecule testing instances"
  default = {
    ubuntu = [
      "jammy-jellyfish"
    ]

    debian = [
      "bookworm"
    ]
  }
}
