#localectl 
#centralized management of language and regional settings.

#display current settings
localectl
localectl status

#explanation of output:
System Locale — current system locale, i.e. set of rules defining system language, currency format, timezone, etc.
VC Keymap — keyboard layout for console.
X11 Layout — keyboard layouts used in graphical system.
X11 Model — keyboard type/model
X11 Variant — keyboard layout variants used in graphical system. Examples: Russian typewriter, DVORAK, QUERTY, etc.
X11 Options — options, including hotkeys for layout switching and displaying current state using Scroll Lock indicator.

#Display list of available locales:
localectl list-locales
#Change system language to English:
localectl set-locale LANG="en_EN.utf8"
#Display list of available keyboard layouts:
localectl list-x11-keymap-layouts
