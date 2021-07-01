#!/bin/bash

# exit when any command fails
set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

REPO="/home/mb/builds/arch_install"
BUILDS="/home/mb/builds"
USERNAME="mb"

mkdir $BUILDS && cd $BUILDS
sudo git clone https://github.com/michaelcbrown/arch_install

# installing yay
sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R $USERNAME:$USERNAME ./yay-git
cd yay-git
makepkg -si

# packages
sudo pacman -S --noconfirm \
    pulseaudio pulseaudio-alsa xorg xorg-xinit xorg-server xterm \
    bspwm sxhkd feh maim xclip picom rofi ttf-font-awesome zsh \
    lightdm papirus-icon-theme lxappearance \
    ranger wget ufw unzip nemo \

yay -S --noconfirm \
    xst canta-gtk-theme lightdm-slick-greeter lightdm-settings polybar mcfly zoxide \


# bspwm et al. config; -p might be necessary so it creates .config
mkdir -p ~/.config/{bspwm,sxhkd}
chmod +x $REPO/bspwmrc
ln -sf $REPO/bspwmrc ~/.config/bspwm
ln -sf $REPO/sxhkdrc ~/.config/sxhkd
ln -sf $REPO/picom ~/.config/picom
ln -sf $REPO/polybar ~/.config/polybar
ln -sf $REPO/rofi ~/.config/rofi
ln -sf $REPO/rifle.conf ~/.config/ranger
ln -sf $REPO/Xresources ~/.Xresources

mkdir -p ~/.local/share/fonts
ln -sf $REPO/fonts ~/.local/share/fonts
fc-cache -fv
cd $REPO/st
make && sudo make install
### can I run xrdb merge .Xresources here? or will it be an error
chsh -s /usr/bin/zsh

# -mkdir -p makes the parent directories if necessary
mkdir -p ~/Pictures/desktop\ backgrounds
cp $REPO/botw.png ~/Pictures/desktop\ backgrounds

# sudo nano /etc/lightdm/lightdm.conf
# Ctrl+W to search for "greeter-session=example"
# Replace example-gtk-gnome with lightdm-slick-greeter and uncomment
# -f is "force" > overwrite conflicting symlinks
sudo systemctl enable lightdm -f

# oh-my-zsh
cd /home/$USERNAME
wget --no-check-certificate http://install.ohmyz.sh -O - | sh
sudo git clone git://github.com/robbyrussell/oh-my-zsh.git
ln -sf $REPO/zshrc/.zshrc ~/.zshrc

# firewall
sudo ufw enable
sudo ufw status verbose
sudo systemctl enable ufw.service
