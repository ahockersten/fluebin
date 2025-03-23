#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

/tmp/fonts.sh
/tmp/gcloud.sh
