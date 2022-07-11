#!/usr/bin/env bash
#
#
# ------------------------------------------------------------------------ #
#
# HOW USE?
#   $ ./ubuntu-postinstall.sh
#
# ----------------------------- VARIABLES ----------------------------- #

##URLS
HYPER_URL="https://releases.hyper.is/download/deb"
INSOMNIA_URL="https://updates.insomnia.rest/downloads/ubuntu/latest?&app=com.insomnia.app&source=website"
EDGE_URL="https://go.microsoft.com/fwlink/?linkid=2124602"
KOMOREBI_URL="https://github.com/cheesecakeufo/komorebi/releases/download/v2.1/komorebi-2.1-64-bit.deb"
## MacOs Shell+Gtk and icons for customization :D
MAC_URL="https://github.com/JohnWick92/post-install-ubuntu/raw/main/MacOsShellIcons.zip"

##DIRECTORYS AND ARCHIVES

DOWNLOADS="$HOME/Downloads"


#COLORS

RED='\e[1;91m'
GREEN='\e[1;92m'
NO_COLOR='\e[0m'


#FUNCTIONS

# BASIC UPDATES AND UPGRADES

apt_update(){
  sudo apt update && sudo apt full-upgrade -y
}

# -------------------------------------------------------------------------------- #
# -------------------------------TEST AND REQUIRIMENTS----------------------------------------- #

# NETWORK TEST
testes_internet(){
if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
  echo -e "${RED}[ERROR] - Seu computador não tem conexão com a Internet. Verifique a rede.${NO_COLOR}"
  exit 1
else
  echo -e "${GREEN}[INFO] - Conexão com a Internet funcionando normalmente.${NO_COLOR}"
fi
}

# ------------------------------------------------------------------------------ #


## REMOVING POSSIBLES LOCKS FOR APT ##
travas_apt(){
  sudo rm /var/lib/dpkg/lock-frontend
  sudo rm /var/cache/apt/archives/lock
}

## UPDATING REPOSITORIES ##
just_apt_update(){
sudo apt update -y
}

##DEB SOFTWARES TO INSTALL

PROGRAMAS_PARA_INSTALAR=(
  snapd
  gparted
  timeshift
  vlc
  code
  gnome-sushi 
  git
  wget
  ubuntu-restricted-extras
  zsh
  gnome-tweaks
 
)

## REMOVE PRE-INSTALLED PROGRAMS ##
remove_pre() {
    sudo snap remove firefox
    sudo snap rm - r firefox
}

# ---------------------------------------------------------------------- #

## Download AND INSTALL .DEB ##

install_debs(){

echo -e "${GREEN}[INFO] - Baixando pacotes .deb${NO_COLOR}"
wget "$HYPER_URL"
wget "$EDGE_URL"
wget "$INSOMNIA_URL"
wget "$KOMOREBI_URL"
wget "$MAC_URL"

## RUNNING DPKG ##
echo -e "${GREEN}[INFO] - Instalando pacotes .deb baixados${NO_COLOR}"
cd $DOWNLOADS
sudo dpkg -i $DOWNLOADS/*.deb

# INSTALL WITH APT
echo -e "${GREEN}[INFO] - Instalando pacotes apt do repositório${NO_COLOR}"

for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    sudo apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done

}

## Instalar beekerper studio ##
install_beekeeper() {
    wget --quiet -O - https://deb.beekeeperstudio.io/beekeeper.key | sudo apt-key add -

# add our repo to your apt lists directory
echo "deb https://deb.beekeeperstudio.io stable main" | sudo tee /etc/apt/sources.list.d/beekeeper-studio-app.list

# Update apt and install
sudo apt update
sudo apt install beekeeper-studio
}

## Instalar docker ##
install_docker() {
     sudo apt-get remove docker docker-engine docker.io containerd runc
      
    sudo apt-get update

    sudo apt-get install \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

     sudo mkdir -p /etc/apt/keyrings

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
}

## Instalando pacotes Flatpak ##
install_flatpaks(){

  echo -e "${GREEN}[INFO] - Instalando pacotes flatpak${NO_COLOR}"

flatpak install flathub org.gimp.GIMP -y
flatpak install flathub com.bitwarden.desktop -y
flatpak install flathub org.telegram.desktop -y
flatpak install flathub org.onlyoffice.desktopeditors -y
}

## Instalando pacotes Snap ##

install_snaps(){

echo -e "${GREEN}[INFO] - Instalando pacotes snap${NO_COLOR}"

sudo snap install authy

}


# -------------------------------------------------------------------------- #
# ----------------------------- POST-INSTALL ----------------------------- #


## CLEANING ##

system_clean(){

apt_update -y
flatpak update -y
sudo apt autoclean -y
sudo apt autoremove -y
nautilus -q
}


# -------------------------------------------------------------------------- #
# ----------------------------- CONFIGS EXTRAS ----------------------------- #


# -------------------------------------------------------------------------------- #
# -------------------------------EXECUTION----------------------------------------- #

travas_apt
testes_internet
travas_apt
apt_update
travas_apt
just_apt_update
install_debs
install_beekeeper
install_docker
install_flatpaks
install_snaps
remove_pre
apt_update
system_clean

## FINNALY

  echo -e "${GREEN}[INFO] - Script finalizado, instalação concluída! :)${NO_COLOR}"
