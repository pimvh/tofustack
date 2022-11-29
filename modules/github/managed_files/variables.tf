variable "repository" {
  type        = string
  description = "repositories to manage files in"
}

variable "path_prefix" {
  type        = string
  default     = null
  description = "a prefix to a path in which to look for file, if the the passed element does not have one"
}

variable "terraform_managed_tag" {
  type        = string
  default     = "# terraform managed"
  description = "tag to indicate that a file is terraform managed"
}

variable "managed_files" {
  type = map(object({
    path = optional(string, null),
  }))
  description = "files to manage in the repository"
}

variable "branch" {
  type        = string
  description = "branch to manage files on"

}
