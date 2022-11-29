variable "github_username" {
  type        = string
  description = "username on Github"
  nullable    = false
}

variable "github_repositories" {
  type = map(object({
    description                = string
    topics                     = optional(list(string), [])
    is_private                 = optional(bool, false)
    license                    = optional(string)
    type                       = optional(string)
    molecule_testing_instances = optional(map(list(string)))
    pinned_versions = optional(map(object({
      version = string
      comment = optional(string, "")
    })), {})
  }))

  description = "Mapping of Github repositories present in the namespace"
  nullable    = false
}

variable "secrets" {
  type        = map(map(string))
  description = "secrets for opentofu to consume"
  nullable    = false
}

variable "pinned_versions" {
  type = map(object({
    version = string
    comment = optional(string, "")
  }))
  description = "versions pinned for packages used in repos"
  nullable    = false
}
