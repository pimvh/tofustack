terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }

    null = {
      source = "hashicorp/null"
    }

    external = {
      source = "hashicorp/external"
    }
  }
}
