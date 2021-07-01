#!/bin/bash

# exit when any command fails
set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

cfdisk
mkfs.ext2 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
pacstrap /mnt base linux linux-firmware base-devel nano sudo git iwd dhcpcd
genfstab -U /mnt >> /mnt/etc/fstab

### arch-chroot
arch-chroot /mnt /bin/bash <<EOF
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
echo "mb_arch" > /etc/hostname
hwclock --systohc
echo "Set system password:"
passwd
useradd -m -G wheel mb
echo "Set user password:"
passwd mb
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
pacman -S grub
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable dhcpcd
mkdir /home/mb/builds && cd /home/mb/builds
git clone https://github.com/michaelcbrown/arch_install
chmod +x arch_install/scripts/first_login.sh
EOF

#curl -LJO https://raw.githubusercontent.com/michaelcbrown/arch_install/master/scripts/after_chroot.sh
#chmod +x after_chroot.sh
#cp -r after_chroot.sh /mnt/root
#arch-chroot /mnt/ /root/after_chroot.sh
#echo "done, reached end"
