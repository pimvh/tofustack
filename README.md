# Introduction

This is the repository I use for managing my GitHub repositories and other relevant things using opentofu. I found that a large number of GitHub repositories I had where quite similar in setup, and parts of it could be templated/generalized in a way that cost me less mental overhead.

While this repository is quite tailored to my way of working and opinionated in its design, I think it could be useful for others as a reference on how to use or not use opentofu to maintain your GitHub repositories.

If you have any good suggestions, on how to improve/change my setup. Please feel free. Questions about design choices are welcome as well.

# Requirements

1. [Nix installed](https://nixos.org/download/)
2. [Nix flakes enabled](https://nixos.wiki/wiki/flakes)

# Organization

Most of this `opentofu` code, is quited specific to my GitHub repository management style, but some things can be easily re-used or adopted when setting up opentofu to manage your GitHub repositories.

## Nix related code

- `pkgs/`: relevant packages which are used inside `flake.nix`
- `overlays/`: relevant overlays which are used in `flake.nix`
- `flake.nix`: nix flake, `default` devShell is bootstrapped by `nix-direnv` (see Usage).

## opentofu code

- `files/` - file templates like GitHub workflows which are pushed via opentofu, per type of repo, see  for example `modules/github/ansible_role_repository/`.
- `graphs`: graphs which are outputs of opentofu
- `modules/` - all opentofu modules, split into:
  - `github`: all github modules
  - `local_ansible`: running ansible locally with opentofu kicking it off, remainder of an experiment (dead code currently)
  - `libvirt`: experiment with `libvirt` provider (dead code currently)
- `secrets.auto.tf.vars.json`: encrypted GitHub secrets as input to opentofu
- `terraform.tfvars` :  all github repositories and versions as input to opentofu
- `*.tfstate`: encrypted opentofu state
- `*.tf` :  opentofu configuration

When running apply, this code will show a nice table display all the stuff that is currently managed, like the following:

```
~ summary_message = <<-EOT
        You currently have 35 Github repositories that are managed by terraform, of which:

            ...
            -> 2 of type unknown

        No repositories are unmanaged!
        Table of managed repositories:
        | type             | name                | description                                                                          | non default configuration   |
        |------------------|---------------------|--------------------------------------------------------------------------------------|-----------------------------|
        | ansible-role     | add_github_hostkeys | Ansible role to add SSH hostkeys for Github                                          |                             |
        ....
```

# Usage

Because I use `direnv`, `opentofu` and other relevant tooling is readily available when I enter the directory of this repository, see [nix-direnv](https://github.com/nix-community/nix-direnv) for reference.

By using a `Makefile`, I can just run  `make apply` to apply opentofu changes, and `make plan` to just plan them out. I looked at other alternatives, like `just` but they didn't bring enough to the table to switch.

Additionally, I use bitwarden to manage secrets, and have hooked that with some scripts to be able to easily retrieve secrets from it.

## Secret rotation

To rotate secrets, use `nix develop '.#encryptSecret'` to kick off the relevant devShell. I've build some stuff to be able to easily rotate secrets by encrypting them with the relevant repository public key.
