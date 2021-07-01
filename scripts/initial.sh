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

curl -LJO https://raw.githubusercontent.com/michaelcbrown/arch_install/master/scripts/after_chroot.sh
chmod +x after_chroot.sh
cp -r after_chroot.sh /mnt/root
arch-chroot /mnt/ /root/after_chroot.sh

echo "done, reached end"
