#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

/ctx/fonts.sh
/ctx/gcloud.sh
