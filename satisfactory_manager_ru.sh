#!/usr/bin/env bash

# Определение пути пользователя для сервера и сохранений
SERVER_DIR="$HOME/SatisfactoryDedicatedServer"
SAVE_GAME_PATH="$HOME/.config/Epic/FactoryGame/Saved/SaveGames/server"
BLUEPRINT_PATH="$HOME/.config/Epic/FactoryGame/Saved/SaveGames/blueprints"
SERVICE_NAME="satisfactory"

# Функция для установки steamcmd
function install_steamcmd() {
    if ! command -v steamcmd &> /dev/null; then
        echo "Устанавливаем steamcmd..."
        sudo apt update
        sudo apt install -y steamcmd
        echo "steamcmd установлен."
    else
        echo "steamcmd уже установлен."
    fi
}

# Функции для установки и обновления сервера
function install_server() {
    echo "Устанавливается сервер Satisfactory..."
    steamcmd +force_install_dir "$SERVER_DIR" +login anonymous +app_update 1690800 validate +quit
    echo "Установка завершена!"
}

function install_server_experimental() {
    echo "Устанавливается экспериментальная версия сервера Satisfactory..."
    steamcmd +force_install_dir "$SERVER_DIR" +login anonymous +app_update 1690800 -beta default validate +quit
    echo "Установка экспериментальной версии завершена!"
}

# Функция для запуска сервера
function start_server() {
    echo "Запуск сервера Satisfactory..."
    "$SERVER_DIR/FactoryServer.sh"
}

# Функция для создания systemd службы
function create_service() {
    echo "Создается systemd служба для сервера Satisfactory..."
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
    echo "Служба создана и включена в автозагрузку!"
}

# Функция для удаления службы
function delete_service() {
    echo "Удаляется systemd служба для сервера Satisfactory..."
    sudo systemctl stop "$SERVICE_NAME"
    sudo systemctl disable "$SERVICE_NAME"
    sudo rm /etc/systemd/system/$SERVICE_NAME.service
    sudo systemctl daemon-reload
    echo "Служба удалена!"
}

# Управление службой
function start_service() {
    sudo systemctl start "$SERVICE_NAME"
    echo "Служба запущена!"
}

function stop_service() {
    sudo systemctl stop "$SERVICE_NAME"
    echo "Служба остановлена!"
}

function restart_service() {
    sudo systemctl restart "$SERVICE_NAME"
    echo "Служба перезапущена!"
}

function status_service() {
    sudo systemctl status "$SERVICE_NAME"
}

# Открытие порта
function open_ports() {
    sudo ufw allow 7777/udp
    sudo ufw allow 7777/tcp
    echo "Порты 7777 открыты!"
}

# Функции для открытия папок
function open_save_folder() {
    xdg-open "$SAVE_GAME_PATH"
}

function open_blueprints_folder() {
    xdg-open "$BLUEPRINT_PATH"
}

# Управление автозапуском
function enable_autostart() {
    sudo systemctl enable "$SERVICE_NAME"
    echo "Автозапуск службы включен!"
}

function disable_autostart() {
    sudo systemctl disable "$SERVICE_NAME"
    echo "Автозапуск службы отключен!"
}

# Главное меню
function show_menu() {
    echo "Выберите действие:"
    echo "1. Установить steamcmd"
    echo "2. Установить/обновить сервер"
    echo "3. Установить/обновить экспериментальную версию сервера"
    echo "4. Запустить сервер вручную"
    echo "5. Создать службу для сервера"
    echo "6. Удалить службу"
    echo "7. Запустить службу"
    echo "8. Остановить службу"
    echo "9. Перезапустить службу"
    echo "10. Проверить статус службы"
    echo "11. Открыть порты"
    echo "12. Открыть папку сохранений"
    echo "13. Открыть папку чертежей"
    echo "14. Включить автозапуск службы"
    echo "15. Отключить автозапуск службы"
    echo "16. Выйти"
    echo
    read -rp "Введите номер действия: " choice
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
        *) echo "Неверный выбор, попробуйте снова." ;;
    esac
}

# Цикл для отображения меню
while true; do
    show_menu
done
