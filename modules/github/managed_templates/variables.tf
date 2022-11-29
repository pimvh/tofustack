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

variable "managed_templates" {
  # use any here due to the fact that a nested any has to evaluate to common type,
  # which we cant enforce here
  type = map(object({
    path = optional(string, null)

    template_values = object({

      # for requirements files
      requirements = optional(map(object({
        version = string
        comment = optional(string, "")
      })), {})

      # for ansible related files
      role_name = optional(string)

      # for molecule.yml
      instance_names   = optional(list(string))
      instances        = optional(map(list(string)))
      default_instance = optional(string)
      default_image_id = optional(string)
    })
  }))

  default     = {}
  description = "templates to manage in the repository"

}

variable "branch" {
  type        = string
  description = "branch to manage files on"
}
