variable "name" {
  type        = string
  nullable    = false
  description = "name of python repository"
}

variable "github_user" {
  type        = any
  description = "name of the github_user"
}

variable "repository_id" {
  type        = string
  nullable    = false
  description = "id of python repository"

}

variable "default_branch" {
  type        = string
  default     = "main"
  nullable    = false
  description = "branch of the python repository to perform actions on"

  validation {
    condition     = var.default_branch == "main"
    error_message = "The default branch of the python repository is probably main"
  }
}

variable "pypi_api_token" {
  type        = string
  nullable    = false
  description = "API token for the package on PyPi"
}
