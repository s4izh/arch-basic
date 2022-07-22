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
pacman -S grub efibootmgr os-prober
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S grub efibootmgr networkmanager network-manager-applet dialogg wpa_supplicant mtools dosfstools base-devel linux-headers bluez bluez-utils cups xdg-utils xdg-user-dirs pulseaudio alsa-utils gvfs


