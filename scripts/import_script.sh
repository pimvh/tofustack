REPOS=("nftables"
       "systemd_failmail"
       "fail2ban"
       "cloud_init"
       "certbot"
       "postfix"
       "libvirt"
       "nsd"
       "ssh_keygen"
       "wireguard"
       "unbound"
       "add_github_hostkeys"
       "simpleNFS"
       "simpleenigma"
       "telegrambot_simple"
       "sudokusolver"
       "dotfiles"
       "rp_parser"
       "fetchmemes"
       "questionair"
       "personal_website"
       "nix-configuration"
       "nvim"
)

for i in $REPOS
do
  tofu import module.managed_github_repositories.github_repository.managed\[\"$i\"\] $i
done;

