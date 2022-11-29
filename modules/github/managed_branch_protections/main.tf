resource "github_branch_protection" "branch" {
  for_each = var.branch_protections

  repository_id = each.value.repository_id
  pattern       = each.key

  allows_deletions                = false
  required_linear_history         = true
  require_conversation_resolution = true

  required_status_checks {
    strict   = length(each.value.required_status_checks) != 0 ? true : false
    contexts = each.value.required_status_checks
  }

  # Only works for organizations
  # restrict_pushes {
  #   push_allowances = var.push_allowances
  # }
}
