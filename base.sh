#!/bin/bash
# https://github.com/sergio-sama/arch-install

# create swap file
# found out (not me) that optimal swapfile size is:
# swap_size = ram_size + sqrt(ram_size) 
fallocate -l 6GB /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile	none	swap	default	0 0" >> etc/fstab

# set localtime
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "es_ES.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

# english install
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# spanish keyboard
echo "KEYMAP=es" >> /etc/vconsole.conf

# host config
echo "arch" >> /etc/hostname
echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1	localhost" >> /etc/hosts
echo "127.0.1.1	arch.localdomain	arch" >> /etc/hosts

# install grub
pacman -S grub efibootmgr dosfstools mtools os-prober

# if efi 
# you should have /dev/boot_partition
# mounted on /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck

# mbr
# grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

grub-mkconfig -o /boot/grub/grub.cfg

pacman -S networkmanager
systemctl enable NetworkManager

pacman -S network-manager-applet dialog wpa_supplicant mtools dosfstools base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync reflector acpi acpi_call virt-manager qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat iptables-nft ipset firewalld flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g sudo
#tlp is optional for laptop

# enable services intalled
# systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
# systemctl enable tlp   
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
systemctl enable firewalld
systemctl enable acpid



# add user
useradd -m s3rgio
usermod -aG wheel,libvirt s3rgio #video,audio,optical,storage,libvrt groups are optional

# sudo
echo "s3rgio ALL=(ALL) ALL" > /etc/sudoers.d/00_s3rgio
# or EDITOR=vim visudo and uncomment %wheel ALL=(ALL:ALL)ALL

echo "Installation finished, setup root and user passwords with passwd"
