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

# Cura configuration
echo "Updating Cura desktop entry"
sudo sed -i 's|^Exec=.*|Exec=UltiMaker-Cura -platformtheme gtk3|' /usr/share/applications/com.ultimaker.cura.desktop

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

# For some gnome apps which prefer light mode
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Remove oprhaned packages
sudo pacman -Rns --noconfirm $(sudo pacman -Qdtq)

echo "Script execution completed successfully!"

