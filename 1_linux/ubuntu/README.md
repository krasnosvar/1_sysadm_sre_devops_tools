#### Ubuntu Desktop restore/setup scripts

```
.
├── ubuntu.sh                    - general Ubuntu commands
├── ubuntu__desktop_24_04_1      - current setup scripts, run in order (see its own README)
├── archive                      - superseded scripts kept for reference
│   ├── .bashrc
│   └── update-desktop-u2204desk.sh   - Ubuntu 22.04 setup (superseded by 24.04.1)
└── wallpaper                    - os_colours.png/.xcf wallpaper assets
```

1. [ubuntu.sh](ubuntu.sh) - general Ubuntu commands
2. [ubuntu__desktop_24_04_1](ubuntu__desktop_24_04_1/README.md) - active first-install/restore scripts for Ubuntu Desktop 24.04.1: run `1_update-desktop-u24_04_1desk.sh`, `2_config_zsh.sh`, `3_config_nvim.sh` in order; `files/` holds the dotfiles/configs they install
3. [archive](archive) - the older 22.04 setup script and bashrc, kept for reference only - not maintained
4. [wallpaper](wallpaper) - wallpaper image and its GIMP (`.xcf`) source
