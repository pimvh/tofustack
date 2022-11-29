variable "name" {
  type        = string
  description = "name of ansible repository"
}

variable "github_user" {
  type        = any
  description = "name of the github_user"
}

variable "repository_id" {
  type        = string
  description = "id of ansible repository"
}

variable "default_branch" {
  type        = string
  default     = "main"
  description = "branch of the ansible repository to perform actions on"

  validation {
    condition     = var.default_branch == "main"
    error_message = "The default branch of the ansible repository is probably main"
  }
}

variable "ansible_galaxy_api_key" {
  type        = string
  description = "API key for Ansible galaxy"
}

variable "pinned_versions" {
  type = map(object({
    version = string
    comment = string
  }))
  nullable    = false
  description = "versions pinned for packages used in repos"
}

variable "molecule_testing_instances" {
  type        = map(list(string))
  description = "molecule testing instances"
  nullable    = false
  default = {
    ubuntu = [
      "jammy-jellyfish"
    ]

    debian = [
      "bookworm"
    ]
  }
}
