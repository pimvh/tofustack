locals {

  github_repositories_names = [for name in keys(var.github_repositories) : name]

  # gather the name of unmanaged github repos, by checking the diff between the data resource and what we know from our variable
  unmanaged_github_repositories_names = setsubtract(var.all_found_github_repositories.names, local.github_repositories_names)

  #
  # build a map that maps the repositories type -> [list of names], adding `unknown` for repos without a type
  #
  github_repositories_types = merge({ for repo, attributes in var.github_repositories : attributes.type => repo... if lookup(attributes, "type", null) != null },
  { for repo, attributes in var.github_repositories : "unknown" => repo... if lookup(attributes, "type", null) == null })

  #
  # get only the length of that list to display in the summary string
  #
  github_repositories_types_length = { for type, repo_names in local.github_repositories_types : type => tostring(length(repo_names)) }

  #
  #  generate a string that summarizes the current state of Github, use a script to generate a table, see data.external.generated_table below
  #

  github_description_string = <<-EOT
    You currently have ${length(var.github_repositories)} Github repositories that are managed by terraform, of which:

    %{for name, type_len in local.github_repositories_types_length~}
    -> ${type_len} of type ${name}
    %{endfor~}

    ${length(local.unmanaged_github_repositories_names) > 0 ? "The following repositories are unmanaged: ${join(",", local.unmanaged_github_repositories_names)}" : "No repositories are unmanaged!"}
    ${trimspace(data.external.generated_table.result.table)}
  EOT
}

data "external" "generated_table" {
  program = ["zsh", "-c", "python3 make_table.py"]

  working_dir = "${path.module}/scripts"

  query = {
    github_repositories    = jsonencode(var.github_repositories)
    non_default_attributes = jsonencode(var.non_default_attributes)
  }
}
