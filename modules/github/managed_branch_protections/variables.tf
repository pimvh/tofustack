variable "branch_protections" {
  type        = map(object({
    repository_id = string
    pattern = string
    required_status_checks = optional(list(string), [])
  }))

  description = "branch_protections for a certain repository"
}
