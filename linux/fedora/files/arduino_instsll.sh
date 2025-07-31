#!/bin/bash

# Stop on error
set -e

echo "🔧 Installing Flatpak and Arduino IDE..."
sudo dnf install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub cc.arduino.arduinoide

echo "🔧 Adding $USER to dialout group..."
sudo usermod -aG dialout "$USER"

echo "⬇️  Downloading Arduino Lab for MicroPython..."
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

URL=$(curl -s https://api.github.com/repos/arduino/arduino-lab-micropython/releases/latest \
  | grep "browser_download_url.*linux-x86_64" | cut -d '"' -f 4)

wget "$URL" -O lab.tar.gz

echo "📦 Extracting to ~/ArduinoLab..."
mkdir -p ~/ArduinoLab
tar -xzf lab.tar.gz -C ~/ArduinoLab --strip-components=1
chmod +x ~/ArduinoLab/arduino-lab-micropython

echo -e "\n✅ Done!"
echo "➡️  Run Arduino IDE with: flatpak run cc.arduino.arduinoide"
echo "➡️  Run Arduino Lab with: ~/ArduinoLab/arduino-lab-micropython"
echo "🔁 Log out and log back in to apply group changes."
