#ubuntu запретить открытие Activities через Super(Win key)
dconf write /org/gnome/mutter/overlay-key "'Alt_R'"

---------------------------------------------------------------------------------------------
#ubuntu 18.04 крышка ноута закрыта но ноут не выключается
vi /etc/systemd/logind.conf
#раскомментировать:
#HandleLidSwitch=ignore


#TRAY
#if copyq icon disappeared from tray
#https://askubuntu.com/questions/1056226/ubuntu-budgie-18-04-lts-system-tray-icons-not-all-showing
sudo apt install libappindicator-dev


#windows apps in ubuntu
https://github.com/Fmstrat/winapps


#How to fix “System program problem detected” error on Ubuntu
https://www.binarytides.com/ubuntu-fix-system-program-problem-error/
sudo rm /var/crash/*
vi /etc/default/apport
service apport stop

#turn off laptop display
#https://askubuntu.com/questions/13433/is-there-a-way-to-turn-off-individual-screens#:~:text=If%20you%20are%20using%20stock,to%20disable%20that%20specific%20monitor.
$ xrandr | grep " connected"
eDP-1 connected 1920x1080+0+0 (normal left inverted right x axis y axis) 344mm x 194mm
DP-1-1 connected 1920x1080+1920+0 (normal left inverted right x axis y axis) 509mm x 286mm
HDMI-1-1 connected primary 1920x1080+3840+0 (normal left inverted right x axis y axis) 509mm x 286mm

$ xrandr --output eDP-1 --brightness 0 


#ubuntu server MIN cloud images
https://cloud-images.ubuntu.com/minimal/releases/focal/release-20210604/


#dell d6000 dock with displaylink
https://gist.github.com/noahp/723832ab8d06770bf6f159c573a65934


# How do you set a default audio output device in Ubuntu
https://askubuntu.com/questions/1038490/how-do-you-set-a-default-audio-output-device-in-ubuntu
https://gist.github.com/ChriRas/b9aef9771a97249cb4620e0d6ef538c4
# Problem
# I have a notebook connected to a port replicator. I want to use the build-in speakers and microfone and not the external ones. If I boot my notebook in my port replicator Ubuntu changes the devices to external.
pactl list short sinks
pactl set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo
pactl list short sources
pactl set-default-source alsa_input.pci-0000_00_1f.3.analog-stereo
# Add to "Startup Applications" ("Startprogramme" in German)
# Open the application "Startup Applications" (Should be preinstalled on Ubuntu)
# Click on "Add"
# Give your startup item a name
# Copy your command from above into the command field.
# Click on "Save".


#install different kernel ( downgrade to 5.5 from 5.15 to allow displaylink )
#1. install kernel
sudo add-apt-repository ppa:cappelikan/ppa
sudo apt update
sudo apt install mainline
sudo mainline
sudo mainline --list
sudo mainline --install 5.5.10
#2. update grub
# https://askubuntu.com/questions/1308901/setting-older-kernel-version-as-default
The simplest solution might be to enable Grub's GRUB_SAVEDEFAULT feature. Try this:

Open the Terminal
Edit the /etc/default/grub file: sudo vi /etc/default/grub
Change GRUB_DEFAULT=0 to GRUB_DEFAULT=saved
Add GRUB_SAVEDEFAULT=true
Save the file (Esc⇢:⇢W⇢X
Update Grub with: sudo update-grub
These settings will ensure that your system boots with the last kernel you chose during boot.
