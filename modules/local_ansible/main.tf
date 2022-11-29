terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
    }
  }
}

data "external" "prepare_ansible_env" {
  /*
    run get_env.zsh script
  */

  program = ["${path.module}/get_env.zsh"]
}
