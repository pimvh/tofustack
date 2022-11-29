#!/usr/bin/env zsh

# Unused.
# Github CLI does not have workflow permissions, hence
# this token only has limited apply functionality and cannot be used.
# keeping it here for demonstration purposes

cat <<EOF
{
  "TOKEN" : "$(gh auth token)"
}
EOF

