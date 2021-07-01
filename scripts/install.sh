#!/bin/bash

# exit when any command fails
set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

### partitioning and initial packages
cfdisk
mkfs.ext2 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
pacstrap /mnt base linux linux-firmware base-devel nano sudo git iwd dhcpcd
genfstab -U /mnt >> /mnt/etc/fstab

###

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

curl -LJO https://raw.githubusercontent.com/michaelcbrown/arch_install/master/scripts/first_login.sh
chmod +rwx first_login.sh
mv first_login.sh /mnt/home/mb
