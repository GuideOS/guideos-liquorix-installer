#!/bin/bash

# Sicherstellen, dass die Verzeichnisse existieren
mkdir -p debian/guideos-liquorix-installer/usr/share/applications
#mkdir -p debian/guideos-ticket-tool/etc/xdg/autostart

# Erstellen der ersten .desktop-Datei
cat > debian/guideos-liquorix-installer/usr/share/applications/guideos-liquorix-installer.desktop <<EOL
[Desktop Entry]
Version=1.0
Name=Liquorix Kernel Installer
Comment=Grafisches Tool zum installieren des Liquorix Kernels
GenericName=Liquorix Kernel Installer
Comment[de_DE]=Grafisches Tool zum installieren des Liquorix Kernels
Comment[en_US]=Graphical tool for installing the Liquorix kernel
Name[de_DE]=Liquorix Kernel Installer
Name[en_US]=Liquorix Kernel Installer
Exec=guideos-liquorix-installer
Icon=guideos-liquorix-installer
Terminal=false
Type=Application
Categories=GuideOS;
StartupNotify=true
EOL