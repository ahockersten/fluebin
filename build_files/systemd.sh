set -euo pipefail

# Global enable: socket is enabled for all users by default; gives the
# Gnome keyring's SSH agent socket without per-user setup.
systemctl --global enable gcr-ssh-agent.socket
