refresh:
  #!/usr/bin/env fish
  source scripts/get_state_passphrase.sh
  tofu init; or return
  tofu refresh -parallelism=10

plan:
  #!/usr/bin/env fish
  source scripts/get_state_passphrase.sh
  tofu init; or return
  tofu plan -refresh=false -parallelism=10

plan_resources:
  #!/usr/bin/env fish
  source scripts/get_state_passphrase.sh
  tofu plan -refresh=false -parallelism=10 2&>1 | rg '^\s+# (module[\.\w\[\]"/]+).*$$' -r '$$1'

apply:
  #!/usr/bin/env fish
  echo -e "initializing..."
  source scripts/get_state_passphrase.sh
  tofu init; or return
  tofu apply -refresh=false -parallelism=10; or return
  echo -e "writing graphs..."
  tofu graph | terraform-graph-beautifier --output-type=cyto-html > graphs/graph.html
  # this graph is possible to make, but not as pretty at the html version
  # tofu graph | terraform-graph-beautifier --output-type=graphviz | dot -T svg > graphs/graph.svg

init:
  #!/usr/bin/env fish
  source scripts/get_state_passphrase.sh
  tofu init

console:
  #!/usr/bin/env fish
  source scripts/get_state_passphrase.sh
  tofu console -plan

upgrade:
  #!/usr/bin/env fish
  source scripts/get_state_passphrase.sh
  tofu init -upgrade
