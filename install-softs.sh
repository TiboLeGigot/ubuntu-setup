#!/bin/bash

# Mode automatique
read -p "Installer tout automatiquement (y/n) ?: " answer
automated=true
case ${answer:0:1} in y | Y)
    echo Mode automatique
    ;;
*)
    automated=false
    echo Mode manuel
    ;;
esac

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sed -i -e 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' .zshrc
echo Oh My Zsh installé avec le thème agnoster

## Configuration git
echo "Configuration de Git"
read -p "Entrer votre mail : " mail
read -p "Entrer votre nom : " name

git config --global user.email "$mail"
git config --global user.name "$name"
git config --global -l | grep user # Output la config git établie par le script

# VS Code
code="VS Code"
install_vscode() {
    echo Installation de $code...
    sudo snap install --classic code
}

if [ "$automated" = false ]; then
    read -p "Installer $code (y/n) ? " answer
    answer=${answer:-y}
    case ${answer:0:1} in y | Y)
        install_vscode
        ;;
    esac
else
    install_vscode
fi

# Google Chrome
chrome="Google Chrome"

install_googlechrome() {
    echo Installation de $chrome...
    sudo sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo apt install google-chrome-stable
}

if [ "$automated" = false ]; then
    read -p "Installer $chrome (y/n) ? " answer
    case ${answer:0:1} in y | Y)
        install_googlechrome
        ;;
    esac
else
    install_googlechrome
fi

# Brave browser
brave="Brave Browser"

install_brave() {

}

if [ "$automated" = false ]; then
    read -p "Installer $brave (y/n) ? " answer
    case ${answer:0:1} in y | Y)
        install_brave
        ;;
    esac
else
    install_brave
fi

# Composer
composer="composer"

install_composer() {
    echo Installation de $composer...

    EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

    if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
        echo >&2 'ERROR: Invalid installer checksum'
        rm composer-setup.php
        exit 1
    fi

    php composer-setup.php --quiet
    RESULT=$?
    rm composer-setup.php
    echo $RESULT

    sudo mv composer.phar /usr/local/bin/composer
}

if [ "$automated" = false ]; then
    read -p "Installer $composer (y/n) ? " answer
    case ${answer:0:1} in y | Y)
        install_composer
        ;;
    esac
else
    install_composer
fi

# Symfony
symfony="symfony"

install_symfony() {
    echo Installation de $symfony...
    echo 'deb [trusted=yes] https://repo.symfony.com/apt/ /' | sudo tee /etc/apt/sources.list.d/symfony-cli.list
    sudo apt update
    sudo apt install symfony-cli
}

if [ "$automated" = false ]; then
    read -p "Installer $symfony (y/n) ? " answer
    case ${answer:0:1} in y | Y)
        install_symfony
        ;;
    esac
else
    install_symfony
fi

# Docker
docker="docker"

install_docker() {
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
}

if [ "$automated" = false ]; then
    read -p "Installer $docker (y/n) ? " answer
    case ${answer:0:1} in y | Y)
        install_docker
        ;;
    esac
else
    install_docker
fi
