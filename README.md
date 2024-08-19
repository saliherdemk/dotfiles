# saliherdemk/dotfiles
My Hyprland configuration

pkglist.txt contains my additional packages.

# Installation

Execute the bash script. Be aware that this contains additional packages that I use.
```
./setup.sh
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

Removes oprhaned packages
```
sudo pacman -Qdtq | sudo pacman -Rns -
```
