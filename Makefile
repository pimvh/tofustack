SHELL := zsh
.SHELLFLAGS = -c

all: plan

.PHONY: refresh plan plan_resources apply init console upgrade

.ONESHELL:
refresh:
	source bwunlock
	source scripts/get_state_passphrase.sh
	tofu init
	tofu refresh -parallelism=10

.ONESHELL:
plan:
	source bwunlock
	source scripts/get_state_passphrase.sh
	tofu init
	tofu plan -refresh=false -parallelism=10

.ONESHELL:
plan_resources:
	source bwunlock
	source scripts/get_state_passphrase.sh
	tofu plan -refresh=false -parallelism=10 2&>1 | rg '^\s+# (module[\.\w\[\]"/]+).*$$' -r '$$1'

.ONESHELL:
apply:
	echo -e "initializing..."
	source bwunlock
	source scripts/get_state_passphrase.sh
	tofu init
	tofu apply -refresh=false -parallelism=10
	echo -e "writing graphs..."
	tofu graph | terraform-graph-beautifier --output-type=cyto-html > graphs/graph.html
	# this graph is possible to make, but not as pretty at the html version
	# tofu graph | terraform-graph-beautifier --output-type=graphviz | dot -T svg > graphs/graph.svg

.ONESHELL:
init:
	source bwunlock
	source scripts/get_state_passphrase.sh
	tofu init

.ONESHELL:
console:
	source bwunlock
	source scripts/get_state_passphrase.sh
	tofu console

.ONESHELL:
upgrade: setup
	source bwunlock
	source scripts/get_state_passphrase.sh
	tofu init -upgrade
