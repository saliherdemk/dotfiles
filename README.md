# saliherdemk/dotfiles
My Hyprland configuration

pkglist.txt contains my additional packages.

# Installation

Execute the bash script. Be aware that this contains additional packages that I use.
```
./setup.sh
```


# Future References

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
