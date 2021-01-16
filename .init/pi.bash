#!/bin/bash -e
NVM_VERSION=0.37.2
UBUNTU_CODENAME=$(lsb_release -cs)
SUPPORTED_CODENAMES="focal" ## 20.04

if [ "$UBUNTU_CODENAME" != "$SUPPORTED_CODENAMES"]; then
  echo "'$UBUNTU_CODENAME' is not supported!"
  read -r -p "Do you still want to continue? [y/N] " response
  case "$response" in
      [yY])
          ;;
      *)
          exit 0;
          ;;
  esac
fi

echo "We need 'sudo' to run this script"
sudo echo "-"

[ -z "${HOME}" ] && echo "\$HOME not specified" && exit 1

sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup

sudo apt-add-repository ppa:git-core/ppa -y
sudo apt update -y ; sudo apt upgrade -y

mkdir -p $HOME/git
mkdir -p $HOME/.bin

sudo apt install -y curl git wget net-tools htop zip unzip samba 
sudo apt install -y wireguard resolvconf inotify-tools
sudo apt install -y docker.io
sudo echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

## NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh | bash

## ZSH
sudo apt install zsh -y
git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
cp $HOME/.oh-my-zsh/templates/zshrc.zsh-template $HOME/.zshrc
sed -i 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"agnoster\"/g' $HOME/.zshrc
git clone https://github.com/zsh-users/zsh-syntax-highlighting $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
sed -i 's/plugins\=(/plugins\=(zsh-autosuggestions zsh-syntax-highlighting /g' $HOME/.zshrc

## Cleanup
sudo apt-get update -y ; sudo apt-get upgrade -y ; sudo apt-get autoremove -y

## Set ZSH as default shell
chsh -s /bin/zsh
