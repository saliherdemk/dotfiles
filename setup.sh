#!/bin/bash

# Exit on error
set -e

# Move pacman.conf to /etc
echo "Moving pacman.conf to /etc/pacman.conf"
sudo mv pacman.conf /etc/pacman.conf

# Update system
echo "Updating system"
sudo pacman -Syu

# Install packages from pkglist.txt
echo "Installing packages from pkglist.txt"
sudo pacman -S --noconfirm - < pkglist.txt

# Install git, base-devel, and yay
echo "Installing git and base-devel, then yay"
sudo pacman -S --needed --noconfirm git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..

# Install packages from yaylist.txt
echo "Installing AUR packages from yaylist.txt"
yay -S --noconfirm - < yaylist.txt

# SDDM configuration
echo "Adding simplicity theme to SDDM themes directory"
sudo cp -r simplicity /usr/share/sddm/themes/

echo "Changing SDDM theme to simplicity"
sudo sed -i 's/^Theme=.*$/Theme=simplicity/' /usr/lib/sddm/sddm.conf.d/default.conf

# Cura configuration
echo "Updating Cura desktop entry"
sudo sed -i 's|^Exec=.*|Exec=UltiMaker-Cura -platformtheme gtk3|' /usr/share/applications/com.ultimaker.cura.desktop

# Zsh configuration
echo "Moving .p10k.zsh to home directory"
mv .p10k.zsh ~/.p10k.zsh

echo "Moving zsh-theme-powerlevel10k to /usr/share"
sudo mv zsh-theme-powerlevel10k /usr/share/zsh-theme-powerlevel10k/

echo "Moving .zshrc to home directory"
mv .zshrc ~/.zshrc

# Change default shell to zsh
echo "Changing default shell to zsh"
chsh -s /usr/bin/zsh

echo "Script execution completed successfully!"
