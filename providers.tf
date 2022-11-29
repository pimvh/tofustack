terraform {
  backend "local" {
    path = "terraform.tfstate"
  }

  # backend "pg" {
  #   conn_str = "postgres://terraform:passwordhere@host_here/terraform_state"
  # }

  encryption {
    method "aes_gcm" "encrypter" {
      keys = key_provider.pbkdf2.default
    }

    state {
      method = method.aes_gcm.encrypter

      enforced = true
    }
  }


  required_providers {
    github = {
      source  = "integrations/github"
      version = "~>6.0.0"
    }

    external = {
      source  = "hashicorp/external"
      version = "~>2.3.3"
    }

    null = {
      source  = "hashicorp/null"
      version = "~>3.2.2"
    }

    local = {
      source  = "hashicorp/local"
      version = "~>2.4.1"
    }

    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~>0.7.6"
    }

  }
}

provider "github" {

  # Using token (oauth does not have workflow permission)
  token = data.external.github_token.result.TOKEN
  owner = "pimvh"
  # Defaults
  # write_delay_ms = 1000
  # read_delay_ms  = 0
}

provider "libvirt" {
  uri = "qemu+ssh://root@bastia.studlab.os3.nl"
}

provider "null" {

}

provider "external" {

}
