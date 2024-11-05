#!/usr/bin/env bash

# Define user paths for the server and saves
SERVER_DIR="$HOME/SatisfactoryDedicatedServer"
SAVE_GAME_PATH="$HOME/.config/Epic/FactoryGame/Saved/SaveGames/server"
BLUEPRINT_PATH="$HOME/.config/Epic/FactoryGame/Saved/SaveGames/blueprints"
SERVICE_NAME="satisfactory"

# Function to install steamcmd
function install_steamcmd() {
    if ! command -v steamcmd &> /dev/null; then
        echo "Installing steamcmd..."
        sudo apt update
        sudo apt install -y steamcmd
        echo "steamcmd installed."
    else
        echo "steamcmd is already installed."
    fi
}

# Functions to install and update the server
function install_server() {
    echo "Installing Satisfactory server..."
    steamcmd +force_install_dir "$SERVER_DIR" +login anonymous +app_update 1690800 validate +quit
    echo "Installation completed!"
}

function install_server_experimental() {
    echo "Installing experimental version of the Satisfactory server..."
    steamcmd +force_install_dir "$SERVER_DIR" +login anonymous +app_update 1690800 -beta experimental validate +quit
    echo "Experimental version installation completed!"
}

# Function to start the server
function start_server() {
    echo "Starting Satisfactory server..."
    "$SERVER_DIR/FactoryServer.sh"
}

# Function to create a systemd service
function create_service() {
    echo "Creating systemd service for the Satisfactory server..."
    sudo bash -c "cat > /etc/systemd/system/$SERVICE_NAME.service <<EOL
[Unit]
Description=Satisfactory dedicated server
Wants=network-online.target
After=syslog.target network.target nss-lookup.target network-online.target

[Service]
ExecStartPre=/usr/games/steamcmd +force_install_dir \"$SERVER_DIR\" +login anonymous +app_update 1690800 validate +quit
ExecStart=$SERVER_DIR/FactoryServer.sh
User=$USER
Group=$USER
Restart=on-failure
RestartSec=60
KillSignal=SIGINT
WorkingDirectory=$SERVER_DIR
[Install]
WantedBy=multi-user.target
EOL"
    sudo systemctl daemon-reload
    sudo systemctl enable "$SERVICE_NAME"
    echo "Service created and enabled on startup!"
}

# Function to delete the service
function delete_service() {
    echo "Deleting systemd service for the Satisfactory server..."
    sudo systemctl stop "$SERVICE_NAME"
    sudo systemctl disable "$SERVICE_NAME"
    sudo rm /etc/systemd/system/$SERVICE_NAME.service
    sudo systemctl daemon-reload
    echo "Service deleted!"
}

# Service management
function start_service() {
    sudo systemctl start "$SERVICE_NAME"
    echo "Service started!"
}

function stop_service() {
    sudo systemctl stop "$SERVICE_NAME"
    echo "Service stopped!"
}

function restart_service() {
    sudo systemctl restart "$SERVICE_NAME"
    echo "Service restarted!"
}

function status_service() {
    sudo systemctl status "$SERVICE_NAME"
}

# Open ports
function open_ports() {
    sudo ufw allow 7777/udp
    sudo ufw allow 7777/tcp
    echo "Ports 7777 opened!"
}

# Functions to open folders
function open_save_folder() {
    xdg-open "$SAVE_GAME_PATH"
}

function open_blueprints_folder() {
    xdg-open "$BLUEPRINT_PATH"
}

# Autostart management
function enable_autostart() {
    sudo systemctl enable "$SERVICE_NAME"
    echo "Service autostart enabled!"
}

function disable_autostart() {
    sudo systemctl disable "$SERVICE_NAME"
    echo "Service autostart disabled!"
}

# Main menu
function show_menu() {
    echo "Select an action:"
    echo "1. Install steamcmd"
    echo "2. Install/update server"
    echo "3. Install/update experimental server version"
    echo "4. Start server manually"
    echo "5. Create service for server"
    echo "6. Delete service"
    echo "7. Start service"
    echo "8. Stop service"
    echo "9. Restart service"
    echo "10. Check service status"
    echo "11. Open ports"
    echo "12. Open save folder"
    echo "13. Open blueprints folder"
    echo "14. Enable service autostart"
    echo "15. Disable service autostart"
    echo "16. Exit"
    echo
    read -rp "Enter action number: " choice
    case $choice in
        1) install_steamcmd ;;
        2) install_server ;;
        3) install_server_experimental ;;
        4) start_server ;;
        5) create_service ;;
        6) delete_service ;;
        7) start_service ;;
        8) stop_service ;;
        9) restart_service ;;
        10) status_service ;;
        11) open_ports ;;
        12) open_save_folder ;;
        13) open_blueprints_folder ;;
        14) enable_autostart ;;
        15) disable_autostart ;;
        16) exit 0 ;;
        *) echo "Invalid choice, please try again." ;;
    esac
}

# Loop to display the menu
while true; do
    show_menu
done
