output "branch_protection" {
  value = {
    "main" = {
      repository_id          = var.repository_id
      pattern                = var.default_branch
    },
  }
  description = "the attributes of the branch protection for this repository"
}
