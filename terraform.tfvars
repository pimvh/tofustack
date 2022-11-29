github_username = "pimvh"

# structure of package versions currently present in repositories
# currently only includes repositories pinned for Ansible
pinned_versions = {
  ansible = {
    version = "9.3.0"
  },

  ansible-lint = {
    version = "24.2.0"
  },

  molecule = {
    version = "24.2.0"
  }

  "molecule-plugins[docker]" = {
    version = "23.5.3"
  },

  pytest-testinfra = {
    version = "10.1.0"
  }
}

# list of repositories, with name a key
# description                --  description of the repo
# licence                    --  license of the repository
# is_private                 --  whether the repo is private
# type                       --  type of repository
# secrets                    --  GitHub secrets which are present in the repository (encrypted using repos public key, see encrypt_secret.py)
# molecule_testing_instances --  map of docker images organized by OS -> version(s)
# pinned_versions            --  map of pinned versions (subset of globally pinned versions, is merged with global map)

github_repositories = {

  #################
  # opentofu
  #################

  tofustack = {
    description = "My personal tofustack"
    license     = "apache-2.0"
    type        = "tofustack"
  },

  #################
  # Ansible roles
  #################

  add_github_hostkeys = {
    description = "Ansible role to add SSH hostkeys for Github"
    license     = "gpl-3.0"
    type        = "ansible-role"
    topics = [
      "github",
      "hostkeys"
    ]
  },

  certbot = {
    description = "Ansible role to configure certbot"
    license     = "gpl-3.0"
    type        = "ansible-role"
    topics = [
      "certbot",
      "tls"
    ]
  },

  cloud_init = {
    description = "Ansible cloud-init role"
    license     = "gpl-3.0"
    topics = [
      "ansible",
      "role",
      "cloud-init",
      "ssh-ca",
      "ansible-pull",
      "dualstack"
    ]
    # TODO: add ansible role
    # type        = "ansible-role"
  },

  fail2ban = {
    description = "Ansible role to install fail2ban"
    license     = "gpl-3.0"
    type        = "ansible-role"
    topics = [
      "fail2ban",
      "hardening"
    ]
  },

  libvirt = {
    description = "Ansible role to manage libvirt VMs"
    license     = "gpl-3.0"
    topics = [
      "ansible",
      "role",
      "hypervisor",
      "dualstack",
      "vm",
    ]
    # TODO: add ansible role
    # type        = "ansible-role"
  },

  nftables = {
    description = "Ansible role to configure nftables"
    license     = "gpl-3.0"
    type        = "ansible-role"
    topics = [
      "firewall",
      "nftables"
    ]
  },

  postfix = {
    description = "Ansible role to setup Postfix"
    license     = "gpl-3.0"
    type        = "ansible-role"
    topics = [
      "postfix",
      "email",
      "dkim",
      "spf",
      "dmarc"
    ]
    molecule_testing_instances = {
      ubuntu = [
        "jammy-jellyfish"
      ]
    }
  },

  nsd = {
    description = "Ansible role to configure NSD"
    license     = "gpl-3.0"
    type        = "ansible-role"
    topics = [
      "nsd",
      "dns-server",
      "dnssec",
      "zsk-rollover",
    ]
    molecule_testing_instances = {
      ubuntu = [
        "jammy-jellyfish"
      ]
    }
  },

  ssh = {
    description = "Ansible role to configure SSH"
    license     = "gpl-3.0"
    type        = "ansible-role"
    topics = [
      "openssh",
      "ssh-ca",
    ]
    molecule_testing_instances = {
      ubuntu = [
        "jammy-jellyfish"
      ]
    }
  }

  ssh_keygen = {
    description = "Ansible role to generate SSH keys"
    license     = "gpl-3.0"
    type        = "ansible-role"
    topics = [
      "sshkeygen",
      "ssh-keys"
    ]
    molecule_testing_instances = {
      ubuntu = [
        "jammy-jellyfish"
      ]
    }
  },

  systemd_failmail = {
    description = "Ansible role to add a failmail systemd service to a host"
    license     = "gpl-3.0"
    type        = "ansible-role"
    topics = [
      "systemd",
      "monitoring",
      "email"
    ]
  },

  unbound = {
    description = "Ansible role to configure Unbound"
    license     = "gpl-3.0"
    type        = "ansible-role"
    topics = [
      "resolver",
      "unbound",
      "dnssec"
    ]
  },

  wireguard = {
    description = "Ansible role to configure Wireguard"
    license     = "gpl-3.0"
    type        = "ansible-role"
    topics = [
      "wireguard",
      "vpn"
    ]
    molecule_testing_instances = {
      ubuntu = [
        "jammy-jellyfish"
      ]
    }
  },

  #################
  # other public repositories
  #################

  "molecule-images" = {
    description = "Docker image used for testing ansible roles with molecule"
    license     = "MIT"
    type        = "molecule-images"
    topics = [
      "docker",
      "molecule",
    ]
  }

  nrich = {
    description = "Nrich.py is a tool to query the shodan internetdb"
    license     = "gpl-3.0"
    type        = "python-package"
    topics = [
      "python",
      "shodan",
      "internetdb"
    ]
  }

  simpleNFS = {
    description = "Simple Network File Share created for masters assignment"
    type        = "python"
  },

  simpleenigma = {
    description = "This repo implements a simple enigma machine"
    type        = "python"
  },

  telegrambot_simple = {
    description = "Implements a simple telegram bot based using the python-telegram-bot wrapper"
    type        = "python"
  },

  sudokusolver = {
    description = "Implements a sudokusolver"
    type        = "python"
  },

  #################
  # private repos
  #################

  ansiblestack = {
    description = "My personal ansiblestack"
    is_private  = true
    type        = "ansiblestack"
  },

  ansiblepull = {
    description = "Ansible pull configuration"
    is_private  = true
    type        = "ansible-playbook"
  },

  dotfiles = {
    description = "My personal dotfiles"
    is_private  = true
    type        = "config-files"
  },

  home-manager = {
    description = "NixOS home-manager configuration"
    is_private  = true
    type        = "nix"
  },

  nix-configuration = {
    description = "NixOS configuration"
    is_private  = true
    type        = "nix"
  },

  pycropster = {
    description = "Python API client for Cropster."
    is_private  = true
    type        = "python"
  }

  nvim = {
    description = "My neovim configuration"
    is_private  = true
    type        = "config-files"
  },

  rp_parser = {
    description = "Parse Research Project from the OS3 website, and mail the differences to an address."
    is_private  = true
    type        = "python"
  },

  fetchmemes = {
    description = "Gets memes from Reddit (RMAAS)"
    is_private  = true
    type        = "python"
  },

  questionair = {
    description = "Questionair script"
    is_private  = true
    type        = "python"
  },

  personal_website = {
    description = "My personal website"
    is_private  = true
    type        = "hugo"
  }

  nextcloud = {
    description = "Nextcloud docker setup for raspberrypi"
    is_private  = true
    type        = "docker"
  },

  homeassistant = {
    description = "Homeassistant docker setup for raspberrypi"
    is_private  = true
    type        = "docker"
  },

  #################
  # old repos
  #################

  datastructuren2019 = {
    description = "Assignments for datastructuren 2019"
    is_private  = true
    type        = "python"
  },

  thesis-code = {
    description = "Code for Bachelor thesis"
    is_private  = true
    type        = "python"
  },

}
