#!/bin/bash

# Mode automatique
read -p "Installer tout automatiquement (y/n) ?: " answer
automated=true
case ${answer:0:1} in
y | Y)
    echo Mode automatique
    ;;
*)
    automated=false
    echo Mode manuel
    ;;
esac

## Mise à jour du système
sudo apt update
sudo apt upgrade
sudo apt full-upgrade

## Installation des soft
packages="curl git zsh fonts-powerline apt-transport-https"
for i in $packages; do
    sudo apt install -y $i
done

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sed -i -e 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' .zshrc

## Configuration git
echo "Configuration de Git"
read -p "Entrer votre mail :" mail
git config --global user.email "$mail"
read -p "Entrer votre nom :" name
git config --global user.name "$name"

# VS Code
code="VS Code"
read -p "Installer $code (y/n) ?" answer
case ${answer:0:1} in
y | Y)
    echo Installation de $code...
    sudo snap install --classic code
    ;;
esac

# Google Chrome
chrome="Google Chrome"
read -p "Installer $chrome (y/n) ?" answer
case ${answer:0:1} in
y | Y)
    echo Installation de $chrome...
    sudo sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo apt install google-chrome-stable
    ;;
esac

# Brave browser
brave="Brave Browser"
read -p "Installer $brave (y/n) ?" answer
case ${answer:0:1} in
y | Y)
    echo Installation de $brave...
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install brave-browser
    ;;
esac

# Docker
docker="docker"
read -p "Installer $docker (y/n) ?" answer
case ${answer:0:1} in
y | Y)
    echo Installation de $docker...
    sudo apt install \
        ca-certificates \
        gnupg \
        lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker
    ;;
esac

echo Finite Incantatem !
