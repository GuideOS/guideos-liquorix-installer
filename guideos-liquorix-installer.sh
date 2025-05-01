#!/bin/bash

# Skript: Liquorix Kernel Installations- und Deinstallations-Tool für GuideOS
# Entwickler: evilware666
# Beschreibung: Dieses Skript ermöglicht die Installation und Deinstallation des Liquorix-Kernels
#              für das Betriebssystem GuideOS. Es bietet eine grafische Benutzeroberfläche via Zenity
#              und synchronisierte Fortschrittsanzeigen.
# Version: 1.0
# Datum: 2025-04-27



# Funktion zum Prüfen, ob der Liquorix-Kernel installiert ist
check_kernel_installed() {
    dpkg --list | grep -i liquorix > /dev/null 2>&1
    return $?
}

# Funktion für die Installation des Liquorix-Kernels
install_kernel() {
    echo "$PASSWORD" | sudo -S bash -c "curl -s 'https://liquorix.net/install-liquorix.sh' | sudo bash"
}

# Funktion für die Deinstallation des Liquorix-Kernels
remove_kernel() {
    KERNELS_TO_REMOVE=$(dpkg --list | grep -i liquorix | awk '{print $2}')
    if [ -n "$KERNELS_TO_REMOVE" ]; then
        if echo "$CURRENT_KERNEL" | grep -i liquorix > /dev/null 2>&1; then
            zenity --warning --title="Achtung!" \
                  --text="Du nutzt gerade den Liquorix-Kernel ($CURRENT_KERNEL).\n\nBitte starte den Rechner neu und wähle im Boot-Menü einen anderen Kernel aus, bevor du versuchst ihn zu deinstallieren."
            exit 1
        fi

        (
            echo "# Deinstallation wird vorbereitet…"
            sleep 1
            echo "# Entferne Kernelpakete…"
            echo "$PASSWORD" | sudo -S apt-get remove --purge -y $KERNELS_TO_REMOVE
            sleep 1
            echo "# Aktualisiere Bootloader…"
            echo "$PASSWORD" | sudo -S update-grub
            sleep 1
            echo "# Deinstallation abgeschlossen."
        ) | zenity --progress \
                  --title="Liquorix Kernel Deinstallation" \
                  --text="Deinstallation läuft…" \
                  --pulsate \
                  --no-cancel \
                  --auto-close

        # Nach Abschluss prüfen und melden
        if ! dpkg --list | grep -i liquorix > /dev/null 2>&1; then
            zenity --info --text="Liquorix Kernel wurde erfolgreich deinstalliert!"
        else
            zenity --error --text="Fehler: Liquorix Kernel konnte nicht entfernt werden!"
        fi
    else
        zenity --error --text="Kein Liquorix Kernel gefunden, der entfernt werden kann."
    fi
}

# Passwortabfrage
PASSWORD=$(zenity --entry --title="Passwortabfrage" \
                  --text="Gib dein Passwort ein:" --hide-text)

# Aktuellen Kernel herausfinden
CURRENT_KERNEL=$(uname -r)

# Benachrichtigung beim Start
zenity --info --title="Aktueller Kernel" \
            --text="Aktuell verwendeter Kernel:\n\n$CURRENT_KERNEL"

# GUI-Auswahl mit Zenity
if check_kernel_installed; then
    ACTION=$(zenity --list --title="Liquorix Kernel" \
                   --column="Aktion" "Deinstallieren")
else
    ACTION=$(zenity --list --title="Liquorix Kernel" \
                   --column="Aktion" "Installieren")
fi

# Aktion ausführen
if [ "$ACTION" == "Installieren" ]; then
    (
        echo "# Starte Liquorix-Installation…"
        install_kernel
        echo "# Installation abgeschlossen."
    ) | zenity --progress \
               --title="Liquorix Kernel Installation" \
               --text="Installation läuft…" \
               --pulsate \
               --no-cancel \
               --auto-close

    # Nach Abschluss prüfen und melden
    if dpkg --list | grep -i liquorix > /dev/null 2>&1; then
        zenity --info --text="Liquorix Kernel wurde erfolgreich installiert!"
    else
        zenity --error --text="Fehler: Liquorix Kernel konnte nicht installiert werden!"
    fi

elif [ "$ACTION" == "Deinstallieren" ]; then
    remove_kernel
fi
