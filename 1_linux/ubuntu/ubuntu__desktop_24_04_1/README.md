# Ubuntu Desktop 24.04 bootstrap

Поддерживаемый компактный baseline без сторонних PPAs и hardcoded user paths.
Большой app/installer inventory вынесен в
[`2_lin_win_mac_apps_bkp`](https://github.com/krasnosvar/2_lin_win_mac_apps_bkp).

```bash
./1_update-desktop-u24_04_1desk.sh --check
./1_update-desktop-u24_04_1desk.sh --devops --dry-run
./1_update-desktop-u24_04_1desk.sh --all
./2_config_zsh.sh
./3_config_nvim.sh
```

Профили: `--minimal`, `--devops`, `--desktop`, `--all`. Bootstrap ставит
packages только из Ubuntu repositories и ограниченный набор известных snaps.
Недоступные элементы перечисляются в конце. Git identity и любые credentials
пользователь задаёт отдельно.
