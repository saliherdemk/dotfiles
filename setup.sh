#!/bin/bash

# Exit on error
set -e

# Copy pacman.conf to /etc
echo "Copying pacman.conf to /etc/pacman.conf"
sudo cp pacman.conf /etc/pacman.conf

# Update system
echo "Updating system"
sudo pacman -Syu --noconfirm

# Install packages from pkglist.txt
echo "Installing packages from pkglist.txt"
sudo pacman -S --noconfirm --needed - < pkglist.txt

# Install git, base-devel, and yay
echo "Installing git and base-devel, then yay"
sudo pacman -S --needed --noconfirm git base-devel

# Remove existing yay directory if it exists
if [ -d "yay" ]; then
  echo "Removing existing yay directory"
  sudo rm -rf yay
fi

# Clone yay repository and build it
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..

# Remove the yay directory
echo "Removing yay directory"
sudo rm -rf yay

# Install packages from yaylist.txt
echo "Installing AUR packages from yaylist.txt"
yay -S --noconfirm --needed - < yaylist.txt

# SDDM configuration
echo "Adding simplicity theme to SDDM themes directory"
sudo cp -r sddm/simplicity /usr/share/sddm/themes/

echo "Changing SDDM theme to simplicity"
sudo sed -i 's/^Current=.*$/Current=simplicity/' /usr/lib/sddm/sddm.conf.d/default.conf

echo "Enabling services"

sudo systemctl enable sddm
sudo systemctl enable NetworkManager

# Zsh configuration
echo "Copying .p10k.zsh to home directory"
cp zsh/.p10k.zsh ~/.p10k.zsh

echo "Copying zsh-theme-powerlevel10k to /usr/share"
sudo cp -r zsh/zsh-theme-powerlevel10k /usr/share/zsh-theme-powerlevel10k/

echo "Copying .zshrc to home directory"
cp zsh/.zshrc ~/.zshrc

# Change default shell to zsh
echo "Changing default shell to zsh"
sudo chsh -s /usr/bin/zsh $(whoami)

# MINEGRUUUB
git clone https://github.com/Lxtharia/minegrub-theme.git
cd ./minegrub-theme
sudo cp -ruv ./minegrub /boot/grub/themes/
sudo sed -i '/^#*GRUB_THEME=/c\GRUB_THEME="/boot/grub/themes/minegrub/theme.txt"' /etc/default/grub
sudo sed -i '/^#*GRUB_DISABLE_OS_PROBER=/c\GRUB_DISABLE_OS_PROBER=false' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
cd ..
rm -rf minegrub-theme
echo "Minegrub theme installed!"

# Setup default apps
xdg-mime default firefox.desktop text/html
xdg-mime default firefox.desktop x-scheme-handler/http
xdg-mime default firefox.desktop x-scheme-handler/https
xdg-mime default thunar.desktop inode/directory
xdg-mime default satty.desktop image/png
xdg-mime default satty.desktop image/jpeg


# For some gnome apps which prefer light mode
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

orphans=$(sudo pacman -Qdtq)

if [ -n "$orphans" ]; then
  sudo pacman -Rns --noconfirm $orphans
else 
  echo "No orphaned packages."
fi

echo "Script execution completed successfully! You may reboot now."
