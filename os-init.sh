#!/bin/bash

## Mise à jour du système
sudo apt update -y
sudo apt upgrade -y 
sudo apt full-upgrade -y

## Installation des packages
packages="curl git zsh fonts-powerline apt-transport-https php php-xml"
for i in $packages; do
    sudo apt install -y $i
done

## Installation des softs
chmod a+x install-softs.sh
./softs.sh

echo Finite Incantatem !
