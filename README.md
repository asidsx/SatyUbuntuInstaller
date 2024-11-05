# SatyUbuntuInstaller
# Satisfactory Dedicated Server Management Script

This script helps manage a Satisfactory dedicated server on Ubuntu. It provides functions for installation, updating, starting, stopping, and managing the server as a systemd service.

## Prerequisites

- Ubuntu operating system
- Administrative (sudo) privileges

## How to Run the Script

1. *Clone the Repository*: First, clone the repository to your local machine.
```
bash
git clone https://github.com/asidsx/SatyUbuntuInstaller.git
cd yourrepository
```

2. *Make the Script Executable*: Ensure the script has execution permissions.
```
bash
chmod +x satisfactory_manager_en.sh
```
or
```
bash
chmod +x satisfactory_manager_ru.sh
```

3. *Run the Script*: Execute the script in your terminal.
```
bash
./satisfactory_manager_en.sh
```
or
```
bash
./satisfactory_manager_ru.sh
```

## Script Functions

The script provides a menu-driven interface with the following options:

1. *Install steamcmd*: Installs SteamCMD, a command-line version of the Steam client, necessary for downloading the server.

2. *Install/Update Server*: Installs or updates the Satisfactory dedicated server to the latest stable version.

3. *Install/Update Experimental Server Version*: Installs or updates the experimental version of the Satisfactory server.

4. *Start Server Manually*: Starts the Satisfactory server manually without using systemd.

5. *Create Service for Server*: Sets up a systemd service for the server, allowing it to start automatically on boot.

6. *Delete Service*: Removes the systemd service.

7. *Start Service*: Starts the server using the systemd service.

8. *Stop Service*: Stops the server if it is running as a systemd service.

9. *Restart Service*: Restarts the server service.

10. *Check Service Status*: Displays the current status of the server service.

11. *Open Ports*: Opens UDP and TCP ports 7777 using UFW (Uncomplicated Firewall) to allow server traffic.

12. *Open Save Folder*: Opens the directory where game saves are stored.

13. *Open Blueprints Folder*: Opens the directory where blueprints are stored.

14. *Enable Service Autostart*: Configures the server service to start automatically on system boot.

15. *Disable Service Autostart*: Disables automatic start of the server service on boot.

16. *Exit*: Exits the script.

## Notes

- Ensure you have the necessary permissions to run the script and modify system files.
- The script is designed for Ubuntu and may require adjustments for other Linux distributions.
- Always back up your game saves and important data before running server updates or changes.

