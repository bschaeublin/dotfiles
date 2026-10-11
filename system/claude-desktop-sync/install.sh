#!/bin/bash
# Install/refresh Claude Desktop repack automation (system files; not applied by chezmoi). Run with sudo.
set -euo pipefail
cd "$(dirname "$0")"
install -Dm755 claude-desktop-sync /usr/local/sbin/claude-desktop-sync
install -Dm644 anthropic.gpg /usr/local/share/claude-desktop-sync/anthropic.gpg
install -Dm644 -t /etc/systemd/system claude-desktop-sync.service claude-desktop-sync.timer
systemctl daemon-reload
systemctl enable --now claude-desktop-sync.timer
systemctl start claude-desktop-sync.service
rpm -q claude-desktop
