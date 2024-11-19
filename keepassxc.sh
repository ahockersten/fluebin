#!/usr/bin/bash

# mostly stolen from https://github.com/m2Giles/m2os/blob/main/flatpak.sh

set -eoux pipefail

flatpak --system install -y org.keepassxc.KeePassXC/x86_64/stable

mkdir -p /usr/share/user-tmpfiles.d

tee /usr/share/user-tmpfiles.d/keepassxc-integration.conf <<EOF
C %h/.var/app/org.mozilla.firefox/.mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json - - - - /run/keepassxc-integration/firefox-keepassxc.json
EOF

tee /usr/lib/tmpfiles.d/keepassxc-integration.conf <<EOF
C %t/keepassxc-integration - - - - /usr/libexec/keepassxc-integration
EOF

tee /usr/lib/systemd/system/flatpak-overrides.service <<EOF
[Unit]
Description=Set Overrides for Flatpaks
ConditionPathExists=!/etc/.%N.stamp
After=local-fs.target

[Service]
Type=oneshot
ExecStart=/usr/libexec/flatpak-overrides.sh
ExecStop=/usr/bin/touch /etc/.%N.stamp

[Install]
WantedBy=default.target multi-user.target
EOF

tee /usr/libexec/flatpak-overrides.sh <<'EOF'
#!/usr/bin/bash

# Mozilla Firefox
flatpak override \
    --system \
    --filesystem=/run/keepassxc-integration \
    --filesystem=/var/lib/flatpak/app/org.keepassxc.KeePassXC:ro \
    --filesystem=/var/lib/flatpak/runtime/org.kde.Platform:ro \
    --filesystem=xdg-data/flatpak/app/org.keepassxc.KeePassXC:ro \
    --filesystem=xdg-data/flatpak/runtime/org.kde.Platform:ro \
    --filesystem=xdg-run/app/org.keepassxc.KeePassXC:create \
    org.mozilla.firefox

chmod +x /usr/libexec/flatpak-overrides.sh
systemctl enable flatpak-overrides.service

mkdir /usr/libexec/keepassxc-integration
tee /usr/libexec/keepassxc-integration/keepassxc-proxy-wrapper <<'EOF'
#!/usr/bin/bash

APP_REF="org.keepassxc.KeePassXC/x86_64/stable"

for inst in "/var/lib/flatpak/" "$HOME/.local/share/flatpak/"; do
    if [ -d "$inst/app/$APP_REF" ]; then
        FLATPAK_INST="$inst"
        break
    fi
done

[ -z "$FLATPAK_INST" ] && exit 1

APP_PATH="$FLATPAK_INST/app/$APP_REF/active"
RUNTIME_REF=$(awk -F'=' '$1=="runtime" { print $2 }' < "$APP_PATH/metadata")
RUNTIME_PATH="$FLATPAK_INST/runtime/$RUNTIME_REF/active"

exec flatpak-spawn \
    --env=LD_LIBRARY_PATH="/app/lib:$APP_PATH" \
    --app-path="$APP_PATH/files" \
    --usr-path="$RUNTIME_PATH/files" \
    -- keepassxc-proxy "$@"
EOF
chmod +x /usr/libexec/keepassxc-integration/keepassxc-proxy-wrapper

tee /usr/libexec/keepassxc-integration/firefox-keepassxc.json <<EOF
{
    "allowed_extensions": [
        "keepassxc-browser@keepassxc.org"
    ],
    "description": "KeePassXC integration with native messaging support",
    "name": "org.keepassxc.keepassxc_browser",
    "path": "/run/keepassxc-integration/keepassxc-proxy-wrapper",
    "type": "stdio"
}
EOF
