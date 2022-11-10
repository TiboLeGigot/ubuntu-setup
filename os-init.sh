#!/bin/bash

## Mise à jour du système
sudo apt update -y
sudo apt upgrade -y
sudo apt full-upgrade -y

## Installation des packages
packages="curl git zsh apt-transport-https neofetch"
for i in $packages; do
    sudo apt install -y $i
done

## Git
echo "Configuration de Git"
mail="t.jeannequin@gmail.com"
name="0xzTraws"

if [ "$automated" = false ]; then
    read -p "Entrer votre mail : " mail
    read -p "Entrer votre nom : " name
fi

git config --global user.email "$mail"
git config --global user.name "$name"
git config --global -l | grep user # Output la config git établie par le script

## Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

## Brave browser
echo Installation du navigateur Brave...
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser

# VSCode
echo Installation de VSCode...
sudo snap install --classic code

# Powerlevel10k
mkdir ~/.fonts
## Téléchargement des fonts
curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -so "MesloLGS NF Regular.ttf"
curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -so "MesloLGS NF Bold.ttf"
curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -so "MesloLGS NF Italic.ttf"
curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -so "MesloLGS NF Bold Italic.ttf"
## Déplace les fonts dans le dossier ~/.fonts pour les rendre disponibles à tous les utilisateurs du système
cp "MesloLGS NF Regular.ttf" "MesloLGS NF Bold.ttf" "MesloLGS NF Italic.ttf" "MesloLGS NF Bold Italic.tt" ~/.fonts
## Suppression des fichiers de fonts téléchargés
rm -rf MesloLGS*
## Set de la police 'MesloLGS' pour le terminal avec le profil par défaut
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ font 'MesloLGS NF Regular 11'
## Override la valeur par défaut de la police et de la taille de font du terminal
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ use-system-font false
## Download du theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k


## Fin du script avec un magnifique sort de Harry Potter
echo Finite Incantatem !
