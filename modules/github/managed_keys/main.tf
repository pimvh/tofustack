locals {
  github_keys = {
    backup = {
      key = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICXbp0wnxYoNsyGJaR8y2ssyfnwdmXYUa2INRdwALgYwAAAAEXNzaDpiYWNrdXAtZ2l0aHVi superpim@nolte"
    },

    xora = {
      key = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAE0p+dl2wU+zS2lBqnzD6GS1+IjQhwumpvSWpi6eBSxAAAACnNzaDpnaXRodWI= superpim@xora"
    },

    hestia = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF1namDOf4nXqyd/4ZTfZZlPzaOTamoBxwh05oLFGix/ pim@cust1009-1"
    },

    nolte = {
      key = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIB/elARZbd2S351cQX+y2dvs5utOgs6azhh371bGju2BAAAAEHNzaDpub2x0ZS1naXRodWI= ssh:nolte-github"
    }

    beko = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJisiZbiYzMiqTqGUg0XyJpjxP288wxhMrA6/P34SEUm"
    },
  }
}

resource "github_user_ssh_key" "managed" {
  for_each = local.github_keys
  title    = each.key
  # Split comment from key
  key = join(" ", slice(split(" ", each.value.key), 0, 2))
}
