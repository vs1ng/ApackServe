# ApackServe
Automatic Directory Backup Script with Apache Integration

This script automates the process of backing up a directory to a remote Apache server and provides access to the backup location.

Features:

    Prompts the user for a directory to backup.
    Creates a local copy of the directory.
    Schedules uploads to the remote Apache server using a systemd service.
    Transfers the backup directory with rsync for efficiency.
    Opens a new shell tab on the server to access the backup (optional).

Requirements:

    Linux system with bash, rsync, cp, systemctl, ssh, and tput (for colored text).
    Systemd service management.
    SSH access with appropriate keys or password for the specified user on the remote server.
    Apache web server installed and configured (hardening is optional).

Instructions:

    Replace placeholders:
        your_server_name: Replace with the hostname or IP address of your Apache server.
        your_username: Replace with the username you have SSH access to on the server.
        /var/www/html/backups: Replace with the desired directory path on the server to store backups.
    Review the script:
        The script utilizes colored text output for better readability.
        Carefully examine the harden_apache function (commented out) before uncommenting as it modifies Apache configurations.
        Removing permissions from the original directory is a risky operation, so leave it commented out unless absolutely necessary.
    Run the script:
        Save the script as backup.sh and run it with bash backup.sh.
        The script will prompt you for the directory to backup.
        After a successful backup, it will display a message and open a new shell tab on the server if configured.

Customization:

    You can modify the systemd service configuration within the script for scheduling adjustments.
    The script can be integrated into a cron job for periodic backups.
