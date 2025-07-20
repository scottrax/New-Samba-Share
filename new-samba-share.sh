#!/bin/bash

set -e

# Check for full Samba server installation
if ! dpkg -l | grep -q "^ii  samba "; then
    echo "[+] Installing full Samba server..."
    sudo apt-get update
    sudo apt-get install -y samba samba-common samba-common-bin
else
    echo "[+] Full Samba server already installed."
fi

# Ensure smbpasswd is present
if ! command -v smbpasswd &> /dev/null; then
    echo "[+] Installing missing smbpasswd..."
    sudo apt-get install -y samba-common-bin
fi

clear
echo "Github repo: https://github.com/scottrax/New-Samba-Share.git"
# Prompt for Samba username
read -p "Enter the Samba username to create: " samba_user

# Create system user if it doesn't exist
if ! id "$samba_user" &>/dev/null; then
    sudo useradd -M -s /usr/sbin/nologin "$samba_user"
    echo "[+] System user '$samba_user' created."
else
    echo "[+] System user '$samba_user' already exists."
fi

# Set Samba password
echo "[*] Set a Samba password for user '$samba_user'"
sudo smbpasswd -a "$samba_user"

# Prompt for directory to share
read -e -p "Enter the full path of the directory to share: " share_dir

# Create directory if needed
if [ ! -d "$share_dir" ]; then
    echo "[!] Directory does not exist. Creating it..."
    sudo mkdir -p "$share_dir"
fi

# Set ownership
sudo chown -R "$samba_user:$samba_user" "$share_dir"

# Ask user what they want the share name to be
read -p "Enter a name for the Samba share (no spaces): " share_name

# Backup config
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

# Add the share if it doesn't already exist
if grep -q "^\[$share_name\]" /etc/samba/smb.conf; then
    echo "[!] Share '$share_name' already exists in smb.conf. Skipping..."
else
    echo "[+] Adding new Samba share '$share_name'..."
    cat <<EOF | sudo tee -a /etc/samba/smb.conf > /dev/null

[$share_name]
   path = $share_dir
   valid users = $samba_user
   read only = no
   browsable = yes
   guest ok = no
EOF
fi

# Restart the correct Samba service
echo "[+] Restarting Samba service..."
if systemctl list-unit-files | grep -q smbd.service; then
    sudo systemctl restart smbd
    sudo systemctl enable smbd
    echo "[+] smbd.service restarted and enabled."
else
    echo "[!] smbd.service not found. You may need to start Samba manually."
    exit 1
fi

echo "[✔] Samba share '$share_name' is ready at: \\$(hostname -I | awk '{print $1}')\$share_name"
