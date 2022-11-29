output "branch_protection" {
  value = {
    "main" = {
      repository_id          = var.repository_id
      pattern                = var.default_branch
      required_status_checks = local.required_status_checks
    },
  }
  description = "the attributes of the branch protection for this repository"
}
