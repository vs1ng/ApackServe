#!/bin/bash

# Function to harden Apache configuration (basic implementation)
harden_apache() {
  # Edit Apache config (replace /etc/apache2/apache2.conf with your actual config file)
  sudo sed -i '/<Directory.*>/,/<\/Directory>/ s/AllowOverride All/AllowOverride None/' /etc/apache2/apache2.conf
  # Restart Apache service
  sudo systemctl restart apache2
}

# Get directory from user with Zenity
src_dir=$(zenity --entry --title "Backup Directory" \
  --text "Enter the directory to backup:")

# Check if directory exists
if [ ! -d "$src_dir" ]; then
  echo "$(tput setaf 1)Error: Directory '$src_dir' does not exist.$(tput sgr0)"
  exit 1
fi

# Define target directory on server
server_name=$(zenity --entry --title "Server Details" \
  --text "Enter server hostname or IP:")
server_dir=$(zenity --entry --title "Server Details" \
  --text "Enter directory path on server (e.g., /var/www/html/backups):")
dest_dir="backup_$(date +%Y-%m-%d)"

# Get username for server access
user_name=$(zenity --entry --title "Server Details" \
  --text "Enter username for SSH access:")

# Create a copy of the directory
cp -r "$src_dir" "$src_dir.bak"

# Systemd service configuration
service_name="backup-$src_dir"

echo "[Unit]
Description=Backup directory $src_dir to $server_name
After=network.target

[Service]
User=$user_name
WorkingDirectory=/home/$user_name
Type=simple
ExecStart=/usr/bin/rsync -avz --delete "$src_dir.bak/" "$server_name:$server_dir/$dest_dir/"

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/$service_name.service

sudo systemctl daemon-reload
sudo systemctl enable $service_name.service
sudo systemctl start $service_name.service
harden_apache  
rsync -avz "$src_dir.bak/" "$server_name:$server_dir/$dest_dir/"
ssh -t $user_name@$server_name "cd $server_dir/$dest_dir && bash"
echo "$(tput setaf 2)Backup completed. Check $server_name:$server_dir/$dest_dir$(tput sgr0)"
