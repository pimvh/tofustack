#!/usr/bin/env zsh

# Check unlocked status of Bitwarden
bw_status=$(bw status --raw | jq .status)

if [[ "$bw_status" != "\"unlocked\"" ]]; then
  echo 'Bitwarden not unlocked' >&2
  exit 1
fi

result="$("bw get --raw password "Opentofu state passphrase"" 2>&1 > /dev/null)"

# if not, exit
if [[ "$result" == "Not found." ]]; then
  echo 'Empty result returned' >&2
  exit 1
fi

# get the password
export TF_ENCRYPTION=$(cat <<EOF
{
  "key_provider": {
    "pbkdf2": {
      "default": {
        "passphrase": "$(bw get --raw password "Opentofu state passphrase")"
      }
    }
  }
}
EOF
)
