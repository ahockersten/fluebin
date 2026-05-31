#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

# chezmoi installed via dnf so it's available BEFORE the first
# `chezmoi init --apply` (brew bundle can't bootstrap chezmoi itself).
dnf -y install chezmoi

/ctx/fonts.sh
/ctx/gcloud.sh
/ctx/sysctl.sh
/ctx/systemd.sh
