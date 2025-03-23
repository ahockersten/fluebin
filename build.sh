#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

/tmp/keepassxc.sh
/tmp/fonts.sh
/tmp/gcloud.sh
