set -euo pipefail

# Install Zed system-wide. The upstream installer writes to $HOME, so we
# redirect HOME to /usr/local/zed and then expose the binary on $PATH.
mkdir -p /usr/local/zed
HOME=/usr/local/zed bash -c 'curl -fLsS https://zed.dev/install.sh | sh'
ln -sf /usr/local/zed/.local/bin/zed /usr/local/bin/zed
