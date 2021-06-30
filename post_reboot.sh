#!/bin/bash

# exit when any command fails
set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

cd ~/builds
sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R mb:mb ./yay-git
cd yay-git
makepkg -si
sudo pacman -S pulseaudio pulseaudio-alsa xorg xorg-xinit xorg-server xterm --noconfirm
sudo pacman -S feh bspwm sxhkd maim xclip picom ttf-font awesome rofi --noconfirm
yay -S polybar xst --noconfirm
mkdir -p ~/.config/bspwm
mkdir -p ~/.config/sxhkd
ln -sf ~/builds/bspwm_dotfiles/bspwmrc ~/.config/bspwm
ln -sf ~/builds/bspwm_dotfiles/sxhkdrc ~/.config/sxhkd
chmod +x ~/builds/bspwm_dotfiles/bspwmrc
ln -sf ~/builds/bspwm_dotfiles/picom ~/.config/picom
ln -sf ~/builds/bspwm_dotfiles/polybar ~/.config/polybar
ln -sf ~/builds/bspwm_dotfiles/rofi ~/.config/rofi
ln -sf ~/builds/bspwm_dotfiles/Xresources ~/.Xresources
cd ~/builds
git clone https://github.com/siduck76/bspwm-dotfiles
mkdir -p ~/.local/share/fonts
cp -r ~/builds/bspwm-dotfiles/fonts\!\ \(\ jetbrainsmono\ nerd\ font\ +\ material\ \) ~/.local/share/fonts
cd ~/.local/share/fonts
fc-cache -fv
rm -rf ~/builds/bspwm-dotfiles
cd ~/builds/bspwm_dotfiles/st
make && sudo make install
### can I run xrdb merge .Xresources here? or will it be an error
sudo pacman -S zsh --noconfirm
chsh -s /usr/bin/zsh
sudo pacman -S papirus-icon-theme --noconfirm
yay -S canta-gtk-theme --noconfirm

# -mkdir -p makes the parent directories if necessary
mkdir -p ~/Pictures/desktop\ backgrounds
mv ~/builds/bspwm_dotfiles/botw.png ~/Pictures/desktop\ backgrounds
