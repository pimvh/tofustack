variable "name" {
  type        = string
  nullable    = false
  description = "name of molecule-images repository"
}

variable "github_user" {
  type        = any
  description = "name of the github_user"
}

variable "repository_id" {
  type        = string
  nullable    = false
  description = "id of molecule-images repository"

}

variable "default_branch" {
  type        = string
  default     = "main"
  nullable    = false
  description = "branch of the molecule-images to perform actions on"

  validation {
    condition     = var.default_branch == "main"
    error_message = "The default branch of the molecule-images repository is probably main"
  }
}

variable "quay_login_password" {
  type        = string
  nullable    = false
  description = "Login for the quay container registry"
}
