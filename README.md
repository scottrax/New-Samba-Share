# New Samba Share Setup Script

This script automates the process of setting up a Samba share on Raspberry Pi OS (or any Debian-based Linux system). It installs Samba if it's missing, prompts for a user, directory, and share name, then configures everything so it's ready to use immediately.

---

## Features

- Installs missing Samba components (`samba`, `samba-common`, `samba-common-bin`)
- Prompts for:
  - Username and password
  - Directory to share
  - Custom share name
- Creates the directory if it doesn't exist
- Sets proper permissions
- Appends the share to `/etc/samba/smb.conf`
- Restarts Samba services to apply changes

---

## Usage

```bash
git clone https://github.com/scottrax/New-Samba-Share.git
cd New-Samba-Share
chmod +x new-samba-share.sh
sudo ./new-samba-share.sh
```

Then just follow the prompts.

---

## Example Output

```bash
Enter the Samba username to create: saturn
[*] Set a Samba password for user 'saturn'
Enter the full path of the directory to share: /media/saturn/storage
Enter a name for the Samba share (no spaces): SaturnShare
[✔] Samba share 'SaturnShare' is ready at: //192.168.0.42/SaturnShare
```

---

## Requirements

- Raspberry Pi OS or other Debian-based distro
- Internet access for package installation
- Root privileges (`sudo` access)

---

## ⚠ Notes

- This script creates a backup of your original `/etc/samba/smb.conf` as `/etc/samba/smb.conf.bak`
- If the share name already exists in the config, it won't be added again
- The shared directory's ownership will be assigned to the Samba user

---

## Tips

- Use `\\<your-pi-ip>\<your-share-name>` to access the share from Windows or other clients
- Use `smbclient -L localhost -U youruser` to verify the share locally
- Use static IPs or hostnames for easier access

---

## Author

**Scott (aka `scottrax`)**  
GitHub: [@scottrax](https://github.com/scottrax)

---

## License

MIT – use it, tweak it, break it, fix it. Just don’t blame me for your network drama.
```
