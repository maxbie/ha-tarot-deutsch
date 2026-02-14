#!/bin/bash

# Tarot für Home Assistant - Installations-Skript
# Dieses Skript installiert alle benötigten Dateien für die Tarot-Integration

set -e  # Bei Fehler abbrechen

echo "🔮 Tarot für Home Assistant - Installation"
echo "=========================================="
echo ""

# Home Assistant Config-Verzeichnis ermitteln
if [ -d "/config" ]; then
    HA_CONFIG="/config"
elif [ -d "$HOME/.homeassistant" ]; then
    HA_CONFIG="$HOME/.homeassistant"
else
    read -p "Bitte geben Sie den Pfad zu Ihrem Home Assistant Config-Verzeichnis ein: " HA_CONFIG
fi

if [ ! -d "$HA_CONFIG" ]; then
    echo "❌ Fehler: Verzeichnis $HA_CONFIG existiert nicht!"
    exit 1
fi

echo "✓ Home Assistant Config gefunden: $HA_CONFIG"
echo ""

# Tarot-Verzeichnis erstellen
echo "📁 Erstelle Tarot-Verzeichnis..."
mkdir -p "$HA_CONFIG/tarot"
mkdir -p "$HA_CONFIG/www/tarot"

# JSON-Datei kopieren
echo "📄 Kopiere Kartendaten..."
cp tarot_cards_de.json "$HA_CONFIG/"

# YAML-Dateien kopieren
echo "⚙️  Kopiere Konfigurationsdateien..."
cp tarot/*.yaml "$HA_CONFIG/tarot/"

echo ""
echo "🎨 Kartenbilder herunterladen..."
echo "   WICHTIG: Die Bilder müssen separat heruntergeladen werden!"
echo ""
echo "   Option 1: Automatisch (benötigt git)"
if command -v git &> /dev/null; then
    read -p "   Sollen die Bilder jetzt automatisch heruntergeladen werden? (j/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Jj]$ ]]; then
        echo "   Lade Bilder herunter..."
        TEMP_DIR=$(mktemp -d)
        git clone --depth 1 https://github.com/metabismuth/tarot-json.git "$TEMP_DIR" 2>/dev/null
        cp -r "$TEMP_DIR/cards/"* "$HA_CONFIG/www/tarot/"
        rm -rf "$TEMP_DIR"
        echo "   ✓ Bilder heruntergeladen!"
    else
        echo "   ⚠ Bitte laden Sie die Bilder manuell herunter:"
        echo "     1. Besuchen Sie: https://github.com/metabismuth/tarot-json"
        echo "     2. Laden Sie den 'cards'-Ordner herunter"
        echo "     3. Kopieren Sie alle Bilder nach: $HA_CONFIG/www/tarot/"
    fi
else
    echo "   ⚠ Git nicht gefunden. Bitte laden Sie die Bilder manuell herunter:"
    echo "     1. Besuchen Sie: https://github.com/metabismuth/tarot-json"
    echo "     2. Laden Sie den 'cards'-Ordner herunter"
    echo "     3. Kopieren Sie alle Bilder nach: $HA_CONFIG/www/tarot/"
fi

echo ""
echo "✅ Installation abgeschlossen!"
echo ""
echo "📋 Nächste Schritte:"
echo "   1. Fügen Sie diese Zeilen zu Ihrer configuration.yaml hinzu:"
echo ""
echo "      input_select: !include tarot/input_select.yaml"
echo "      sensor: !include tarot/sensor.yaml"
echo "      script: !include tarot/scripts.yaml"
echo "      automation: !include tarot/automations.yaml"
echo ""
echo "   2. Starten Sie Home Assistant neu"
echo "   3. Fügen Sie eine Dashboard-Karte hinzu (siehe lovelace_cards.yaml)"
echo ""
echo "🔮 Viel Freude mit Ihren Tarot-Lesungen!"
