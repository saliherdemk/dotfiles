# saliherdemk/dotfiles
My Hyprland configuration

pkglist.txt contains my additional packages.

# Installation
Move pacman.conf to `/etc/pacman.conf`

then

```
pacman -Syu
```

```
pacman -S - < pkglist.txt
```

And

```
pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
```

then

```
yay -S - < yaylist.txt
```

# sddm
Add simplicity theme to `/usr/share/sddm/themes/ `

then change theme name to `simplicity` on `/usr/lib/sddm/sddm.conf.d/default.conf`

# Cura
Change Exec line on `/usr/share/applications/com.ultimaker.cura.desktop` to 
```
Exec=UltiMaker-Cura -platformtheme gtk3
```

# zsh
Move `.p10k.zsh` to ``~/.p10k.zsh``

Move `zsh-theme-powerlevel10k` to `/usr/share/zsh-theme-powerlevel10k/`

And

Move `.zshrc` to `~/.zshrc`

Dont' forget to change default bash

```
chsh
```

```
/usr/bin/zsh
```

# Future References
[gnome-disk-utility](https://archlinux.org/packages/extra/x86_64/gnome-disk-utility/) for manipulating `fstab`

[gparted](https://archlinux.org/packages/extra/x86_64/gparted/) for partitioning

```
pacman -Qqen > pkglist.txt
```

```
pacman -Qqem > yaylist.txt
```

```
dconf dump / > dconf.settings.ini
```

```
sudo pacman -Qdtq | sudo pacman -Rns -
```
