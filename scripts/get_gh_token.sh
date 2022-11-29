#!/usr/bin/env zsh

# Check unlocked status of Bitwarden
bw_status=$(bw status --raw | jq .status)

if [[ "$bw_status" != "\"unlocked\"" ]]; then
  echo 'Bitwarden not unlocked' >&2
  exit 1
fi

result="$("bw get --raw password "Opentofu Github token"" 2>&1 > /dev/null)"

# if not, exit
if [[ "$result" == "Not found." ]]; then
  echo 'Empty result returned' >&2
  exit 1
fi

# get the password

cat <<EOF
{

  "TOKEN" : "$(bw get --raw password "Opentofu Github token")"
}
EOF

