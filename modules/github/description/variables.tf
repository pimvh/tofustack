variable "github_repositories" {
  type = map(object({
    description                = string
    is_private                 = optional(bool, false)
    license                    = optional(string)
    topics                     = optional(list(string), [])
    type                       = optional(string)
    molecule_testing_instances = optional(map(list(string)))
    secrets = optional(object({
      ansible_galaxy_api_key = optional(string, null)
      quay_login_password    = optional(string, null)
    }))
    pinned_versions = optional(map(object({
      version = string
    })))
  }))

  description = "Mapping of Github repositories present in the namespace"
  nullable    = false
}

variable "all_found_github_repositories" {
  type = object({
    names = list(string)
  })
  description = "List of Github repositories found in the user account"
  nullable    = false
}

variable "non_default_attributes" {
  type        = list(string)
  description = "List of attributes of github_repositories that are considered non default"
  nullable    = false
}
