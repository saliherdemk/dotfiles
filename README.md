# saliherdemk/dotfiles
My Hyprland configuration on Arch Linux (btw) 

pkglist.txt contains my additional packages.

```
pacman -Qqen > pkglist.txt
```

```
pacman -Qqem > yaylist.txt
```

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
yay -S - <yaylist.txt
```

# sddm
Add simplicity theme to `/usr/share/sddm/themes/ `

then change theme name to `simplicity` on `/usr/lib/sddm/sddm.conf.d/default.conf`

# zsh
Move `.p10k.zsh` to ``~/.p10k.zsh``

And

Move `.zshrc` to `~/.zshrc`

