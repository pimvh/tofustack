output "summary_message" {
  value       = module.managed_github_repositories.github_description_message
  description = "A string that describes the status of Github"
}
