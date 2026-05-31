set -euo pipefail

# Bluefin DX includes Homebrew via /usr/bin/brew shim + first-boot lazy
# install; we don't run brew here. The Brewfile is laid down so the
# environment repo's run_once_before_10-brew-bundle-linux.sh.tmpl
# (executed by chezmoi on first apply) can consume it.
install -D -m 0644 /ctx/Brewfile /usr/share/fluebin/Brewfile
