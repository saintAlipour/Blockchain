#!/bin/bash
#
# setup_node_user.sh
# ---------------------------------------------------------
# Creates a dedicated, low-privilege system user to run
# the blockchain node.
# Running the node as its own user (instead of root) limits
# the blast radius if the node process is ever compromised.
#
# Usage:
#   sudo ./setup_node_user.sh
# ---------------------------------------------------------

# --- Safety flags ---
# -e: exit on error
# -u: error on undefined variable
# -o pipefail: catch errors in pipes
set -euo pipefail

# --- Main variables ---
NODE_USER="blockchain-node"
NODE_HOME="/opt/blockchain-node"
NODE_GROUP="blockchain-node"

# --- 1. Must be run as root ---
if [ "$EUID" -ne 0 ]; then
  echo "[-] Please run this script with sudo."
  exit 1
fi

# --- 2. Create the group if it doesn't exist ---
if ! getent group "$NODE_GROUP" > /dev/null; then
  groupadd "$NODE_GROUP"
  echo "[+] Group '$NODE_GROUP' created."
else
  echo "[i] Group '$NODE_GROUP' already exists."
fi

# --- 3. Create the user if it doesn't exist ---
# --system      : system user (UID < 1000)
# --gid         : primary group
# --home-dir    : home directory path
# --create-home : create the home directory
# --shell       : no login shell (nologin)
if ! id "$NODE_USER" &>/dev/null; then
  useradd \
    --system \
    --gid "$NODE_GROUP" \
    --home-dir "$NODE_HOME" \
    --create-home \
    --shell /usr/sbin/nologin \
    "$NODE_USER"
  echo "[+] User '$NODE_USER' created (no login shell, no sudo)."
else
  echo "[i] User '$NODE_USER' already exists."
fi

# --- 4. Set ownership and permissions on the node home ---
# chown: give ownership to the node user and group
# chmod 750: owner can rwx, group can r-x, others have no access
chown -R "$NODE_USER":"$NODE_GROUP" "$NODE_HOME"
chmod 750 "$NODE_HOME"
echo "[+] Ownership and permissions set on $NODE_HOME."

# --- 5. (Optional) Create a systemd service file ---
SERVICE_FILE="/etc/systemd/system/node.service"
if [ ! -f "$SERVICE_FILE" ]; then
  cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Blockchain Node Service
After=network.target

[Service]
Type=simple
User=$NODE_USER
Group=$NODE_GROUP
WorkingDirectory=$NODE_HOME
ExecStart=$NODE_HOME/start_node.sh
Restart=on-failure
RestartSec=5

# Extra hardening for the systemd unit
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ReadWritePaths=$NODE_HOME

[Install]
WantedBy=multi-user.target
EOF
  echo "[+] systemd service file created at $SERVICE_FILE."
  echo "    Edit ExecStart to point at your actual node start command."
else
  echo "[i] $SERVICE_FILE already exists, skipping."
fi

# --- 6. Reload systemd (only if systemctl is available) ---
# This avoids failure in environments without systemd (e.g. Docker)
if command -v systemctl &>/dev/null; then
  systemctl daemon-reload
fi

# --- 7. Final summary ---
echo ""
echo "[✓] Done. Summary:"
echo "    User:    $NODE_USER"
echo "    Group:   $NODE_GROUP"
echo "    Home:    $NODE_HOME"
echo "    Service: $SERVICE_FILE (not started — run 'systemctl enable --now node' when ready)"