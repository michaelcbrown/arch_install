#!/bin/bash

# exit when any command fails
set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

REPO="home/mb/builds/bspwm_dotfiles"
BUILDS="home/mb/builds"
USERNAME="mb"

# installing yay
sudo git clone https://aur.archlinux.org/yay-git.git $BUILDS
sudo chown -R $USERNAME:$USERNAME ./yay-git
cd yay-git
makepkg -si

# packages
sudo pacman -S --noconfirm \
    pulseaudio pulseaudio-alsa xorg xorg-xinit xorg-server xterm \
    bspwm sxhkd feh maim xclip picom rofi ttf-font-awesome zsh \
    lightdm papirus-icon-theme \
    ranger wget \
    /
yay -S --noconfirm \
    polybar xst canta-gtk-theme lightdm-slick-greeter lightdm-settings \
    /

# bspwm et al. config
mkdir -p ~/.config/bspwm
mkdir -p ~/.config/sxhkd
ln -sf $REPO/bspwmrc ~/.config/bspwm
ln -sf $REPO/sxhkdrc ~/.config/sxhkd
chmod +x $REPO/bspwmrc
ln -sf $REPO/picom ~/.config/picom
ln -sf $REPO/polybar ~/.config/polybar
ln -sf $REPO/rofi ~/.config/rofi
ln -sf $REPO/Xresources ~/.Xresources

mkdir -p ~/.local/share/fonts
ln -sf $REPO/fonts ~/.local/share/fonts
fc-cache -fv
cd ~/builds/bspwm_dotfiles/st
make && sudo make install
### can I run xrdb merge .Xresources here? or will it be an error
chsh -s /usr/bin/zsh

# -mkdir -p makes the parent directories if necessary
mkdir -p ~/Pictures/desktop\ backgrounds
mv $REPO/botw.png ~/Pictures/desktop\ backgrounds

# sudo nano /etc/lightdm/lightdm.conf
# Ctrl+W to search for "greeter-session=example"
# Replace example-gtk-gnome with lightdm-slick-greeter and uncomment
sudo systemctl enable lightdm

# oh-my-zsh
wget --no-check-certificate http://install.ohmyz.sh -O - | sh
sudo git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

