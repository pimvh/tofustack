variable "name" {
  type        = string
  nullable    = false
  description = "name of ansible repository"
}

variable "github_user" {
  type        = any
  description = "name of the github_user"
}

variable "repository_id" {
  type        = string
  nullable    = false
  description = "id of ansible repository"
}

variable "default_branch" {
  type        = string
  default     = "main"
  nullable    = false
  description = "branch of the ansible repository to perform actions on"

  validation {
    condition     = var.default_branch == "main"
    error_message = "The default branch of the ansible repository is probably main"
  }
}
variable "pinned_versions" {
  type = map(object({
    version = string
    comment = string
  }))
  nullable    = false
  description = "versions pinned for packages used in repos"
}
