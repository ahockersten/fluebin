set -euo pipefail

flatpak --system install -y --noninteractive flathub \
    org.signal.Signal \
    com.valvesoftware.Steam \
    io.github.nokse22.high-tide
