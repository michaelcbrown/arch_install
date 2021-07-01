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


### partitioning and initial packages
partitioning () {
    cfdisk
    mkfs.ext2 /dev/sda1
    mkfs.ext4 /dev/sda2
    mount /dev/sda2 /mnt
    pacstrap /mnt base linux linux-firmware base-devel nano sudo git iwd dhcpcd
    genfstab -U /mnt >> /mnt/etc/fstab
}

### stuff within arch_chroot
chrooting () {
    arch-chroot /mnt sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
    arch-chroot /mnt locale-gen
    arch-chroot /mnt echo "LANG=en_US.UTF-8" > /etc/locale.conf
    arch-chroot /mnt ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
    arch-chroot /mnt echo "mb_arch" > /etc/hostname
    arch-chroot /mnt hwclock --systohc
    arch-chroot /mnt passwd
    arch-chroot /mnt useradd -m -G wheel mb
    arch-chroot /mnt passwd mb
    #printf "#$USERPW\N$USERPW" | arch-chroot /mnt passwd mb
    arch-chroot /mnt sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
    arch-chroot /mnt pacman -S grub
    arch-chroot /mnt grub-install /dev/sda
    arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
    arch-chroot /mnt systemctl enable dhcpcd
}


#curl -LJO https://raw.githubusercontent.com/michaelcbrown/arch_install/master/scripts/first_login.s
#chown 
#chmod +rwx first_login.sh
#mv first_login.sh /mnt/home/mb


clone_repo () {
    mkdir $BUILDS && cd $BUILDS
    sudo git clone https://github.com/michaelcbrown/arch_install
}

install_initial_packages () {
    sudo pacman -S --noconfirm \
        pulseaudio pulseaudio-alsa xorg xorg-xinit xorg-server xterm \
        bspwm sxhkd feh maim xclip picom rofi ttf-font-awesome zsh \
        lightdm papirus-icon-theme lxappearance \
        ranger wget ufw unzip nemo \
    
    cd $BUILDS
    sudo git clone https://aur.archlinux.org/yay-git.git
    sudo chown -R $USERNAME:$USERNAME ./yay-git
    cd yay-git
    makepkg -si
    
    yay -S --noconfirm \
        xst canta-gtk-theme lightdm-slick-greeter lightdm-settings polybar mcfly zoxide \
}

configure_bspwm () {
    mkdir -p ~/.config/{bspwm,sxhkd}
    chmod +x $REPO/bspwmrc
    ln -sf $REPO/bspwmrc ~/.config/bspwm/
    ln -sf $REPO/sxhkdrc ~/.config/sxhkd/
    ln -sf $REPO/picom ~/.config/picom
    ln -sf $REPO/polybar ~/.config/polybar
    ln -sf $REPO/rofi ~/.config/rofi
    ln -sf $REPO/rifle.conf ~/.config/ranger/
    ln -sf $REPO/Xresources ~/.Xresources

    mkdir -p ~/.local/share/fonts
    ln -sf $REPO/fonts ~/.local/share/fonts
    fc-cache -fv
    cd $REPO/st
    make && sudo make install
    ### can I run xrdb merge .Xresources here? or will it be an error
    chsh -s /usr/bin/zsh
}

other_basics () {
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
}

if [ $# -eq 0 ]
then
    partitioning
    chrooting
else
    clone_repo
    install_initial_packages
    configure_bspwm
    other_basics
fi
