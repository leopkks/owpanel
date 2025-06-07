#!/bin/sh

echo -e "\nOLS Panel is now starting soon please wait...\n"

# Detect OS version
OUTPUT=$(cat /etc/*release)

if echo "$OUTPUT" | grep -q "Ubuntu 18.04"; then
    SERVER_OS="Ubuntu"
elif echo "$OUTPUT" | grep -q "Ubuntu 20.04"; then
    SERVER_OS="Ubuntu"
elif echo "$OUTPUT" | grep -q "Ubuntu 22.04"; then
    SERVER_OS="Ubuntu"
elif echo "$OUTPUT" | grep -q "Ubuntu 24.04"; then
    SERVER_OS="Ubuntu"
elif echo "$OUTPUT" | grep -q "Debian"; then
    SERVER_OS="Debian"
else
    echo -e "\nOLS Panel is supported only on Ubuntu 18.04, 20.04, 22.04, 24.04, Debian 11, 12. Other OS support coming soon.\n"
    exit 1
fi

# Atualiza e instala dependências
sudo apt update -qq && sudo apt install -y -qq wget curl

echo -e "\nYour OS is $SERVER_OS\n"

# Baixa e executa o painel
wget -O panel.sh "https://raw.githubusercontent.com/osmanfc/owpanel/main/$SERVER_OS/panel.sh"
wget -O requirements.txt "https://raw.githubusercontent.com/osmanfc/owpanel/main/requirements.txt"

chmod +x panel.sh
sed -i 's/\r$//' panel.sh

sh panel.sh
