#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

RELEASE="$(rpm -E %fedora)"

# chezmoi installed via dnf so it's available BEFORE the first
# `chezmoi init --apply` (brew bundle can't bootstrap chezmoi itself).
dnf -y install chezmoi

/ctx/fonts.sh
/ctx/systemd.sh
