#!/bin/bash
cd ~/builds
sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R mb:mb ./yay-git
cd yay-git
makepkg -si
sudo pacman -S pulseaudio pulseaudio-alsa xorg xorg-xinit xorg-server xterm
sudo pacman -S feh bspwm sxhkd maim xclip picon ttf-font awesome rofi
yay -S polybar xst
mkdir ~/.config/bspwm
mkdir ~/.config/sxhkd
ln -sf ~/builds/bspwm_dotfiles/bspwmrc ~/.config/bspwm
ln -sf ~/builds/bspwm_dotfiles/sxhkdrc ~/.config/sxhkd
chmod +x ~/builds/bspwm_dotfiles/bspwmrc
ln -sf ~/builds/bspwm_dotfiles/picom ~/.config/picom
ln -sf ~/builds/bspwm_dotfiles/polybar ~/.config/polybar
ln -sf ~/builds/bspwm_dotfiles/rofi ~/.config/rofi
ln -sf ~/builds/bspwm_dotfiles/Xresources ~/.Xresources
git clone https://github.com/siduck76/bspwm-dotfiles
mkdir ~/.local
mkdir ~/.local/share
mkdir ~/.local/share/fonts
cp ~/builds/bspwm_dotfiles/fonts\!\ \(\ jetbrainsmono\ nerd\ font\ +\ material/ /) ~/.local/share/fonts
cd ~/.local/share/fonts
fc-cache -fv
cd ~/builds/bspwm_dotfiles
make && sudo make install
### can I run xrdb merge .Xresources here? or will it be an error
sudo pacman -S zsh
chsh -s /usr/bin/zsh
sudo pacman -S papirus-icon-theme
yay -S canta-gtk-theme
