# 🔮 Home Assistant Tarot auf Deutsch

Ein vollständiges deutsches Tarot-Deck für Home Assistant mit allen 78 Karten, inklusive Bildern und Bedeutungen.

## 📋 Übersicht

Dieses Projekt ermöglicht es Ihnen, tägliche Tarot-Lesungen in Home Assistant durchzuführen. Ziehen Sie auf Knopfdruck eine zufällige Karte mit deutscher Beschreibung und passendem Bild.

### Features

- ✨ Alle 78 Tarotkarten (22 Große Arkana + 56 Kleine Arkana)
- 🇩🇪 Vollständig auf Deutsch (Namen und Bedeutungen)
- 🎨 Schöne Kartenbilder vom Rider-Waite Tarot
- 🏠 Einfache Integration in Home Assistant
- 📱 Dashboard-Karten für die Anzeige
- 🔘 Automatisierungen für tägliche Lesungen

## 📦 Installation

### 1. Repository klonen

```bash
cd /config
git clone https://github.com/IHR-USERNAME/ha-tarot-deutsch.git
```

### 2. Bilder herunterladen

Die Tarot-Bilder stammen aus dem [tarot-json Repository](https://github.com/metabismuth/tarot-json):

```bash
# Repository mit Bildern klonen
git clone https://github.com/metabismuth/tarot-json.git /tmp/tarot-json

# Bilder-Ordner in Home Assistant www-Verzeichnis kopieren
mkdir -p /config/www/tarot
cp -r /tmp/tarot-json/cards/* /config/www/tarot/
```

**Alternative:** Laden Sie die Bilder manuell herunter:
1. Besuchen Sie https://github.com/metabismuth/tarot-json
2. Laden Sie den `cards`-Ordner herunter
3. Kopieren Sie alle Bilder nach `/config/www/tarot/`

### 3. JSON-Datei platzieren

```bash
# JSON-Datei ins config-Verzeichnis kopieren
cp ha-tarot-deutsch/tarot_cards_de.json /config/
```

### 4. Home Assistant Konfiguration hinzufügen

Fügen Sie die Inhalte aus `configuration.yaml` in Ihre Home Assistant Konfiguration ein oder inkludieren Sie die Dateien:

```yaml
# In Ihrer configuration.yaml
input_select: !include tarot/input_select.yaml
sensor: !include tarot/sensor.yaml
script: !include tarot/scripts.yaml
automation: !include tarot/automations.yaml
```

### 5. Home Assistant neu starten

Nach der Konfiguration starten Sie Home Assistant neu:
- **Einstellungen** → **System** → **Neu starten**

## 🎴 Verwendung

### Manuelle Kartenziehung

1. Gehen Sie zu **Entwicklerwerkzeuge** → **Dienste**
2. Wählen Sie den Dienst `script.tarot_karte_ziehen`
3. Klicken Sie auf **Dienst aufrufen**

### Dashboard-Integration

Fügen Sie eine der folgenden Karten zu Ihrem Dashboard hinzu:

#### Einfache Karte (Markdown)

```yaml
type: markdown
content: >
  ## 🔮 Tägliche Tarot-Karte

  **{{ states('input_select.tarot_karte_name') }}**

  ![Tarot]({{ states('sensor.tarot_karte_bild') }})

  {{ states('sensor.tarot_karte_bedeutung') }}
```

#### Erweiterte Karte (Picture-Entity)

Siehe `lovelace_cards.yaml` für detailliertere Beispiele.

### Tägliche automatische Lesung

Die mitgelieferte Automatisierung zieht jeden Morgen um 07:00 Uhr automatisch eine neue Karte:

```yaml
# In automations.yaml bereits enthalten
- alias: "Tägliche Tarot-Karte"
  trigger:
    - platform: time
      at: "07:00:00"
  action:
    - service: script.tarot_karte_ziehen
```

Sie können die Zeit nach Belieben anpassen.

## 📂 Dateistruktur

```
ha-tarot-deutsch/
├── README.md                    # Diese Datei
├── tarot_cards_de.json         # Hauptdatei mit allen 78 Karten
├── configuration.yaml          # Beispiel-Konfiguration
├── tarot/
│   ├── input_select.yaml       # Input Select für Kartennamen
│   ├── sensor.yaml             # Sensoren für Bild und Bedeutung
│   ├── scripts.yaml            # Skript zum Karten ziehen
│   └── automations.yaml        # Automatisierung für tägliche Karte
└── lovelace_cards.yaml         # Beispiel Dashboard-Karten
```

## 🎯 Funktionsweise

1. **JSON-Datei**: Enthält alle 78 Karten mit deutschen Namen, englischen Namen, Bilddateinamen und Bedeutungen
2. **Input Select**: Speichert den aktuell gezogenen Kartennamen
3. **Template Sensoren**: Lesen die Karteninformationen aus der JSON-Datei basierend auf dem Input Select
4. **Script**: Wählt eine zufällige Karte und aktualisiert den Input Select
5. **Automatisierung**: Führt das Script täglich automatisch aus

## 🔧 Anpassungen

### Kartenbilder ändern

Die Bilder befinden sich in `/config/www/tarot/`. Sie können diese durch eigene Bilder ersetzen, solange die Dateinamen mit der JSON-Datei übereinstimmen.

### Zeit der täglichen Lesung ändern

Bearbeiten Sie in `automations.yaml`:

```yaml
trigger:
  - platform: time
    at: "09:30:00"  # Ihre gewünschte Zeit
```

### Weitere Automatisierungen

Sie können beliebig viele Automatisierungen hinzufügen, z.B.:
- Wöchentliche Lesungen
- Kartenziehung bei bestimmten Events
- Benachrichtigungen mit der Kartenbedeutung

## 📖 Kartenübersicht

Das Deck enthält:

### Große Arkana (22 Karten)
0. Der Narr
1. Der Magier
2. Die Hohepriesterin
3. Die Herrscherin
4. Der Herrscher
5. Der Hierophant
6. Die Liebenden
7. Der Wagen
8. Die Kraft
9. Der Eremit
10. Das Rad des Schicksals
11. Die Gerechtigkeit
12. Der Gehängte
13. Der Tod
14. Die Mäßigung
15. Der Teufel
16. Der Turm
17. Der Stern
18. Der Mond
19. Die Sonne
20. Das Gericht
21. Die Welt

### Kleine Arkana (56 Karten)
- **Stäbe** (Wands): As bis König (14 Karten)
- **Kelche** (Cups): As bis König (14 Karten)
- **Schwerter** (Swords): As bis König (14 Karten)
- **Münzen** (Pentacles): As bis König (14 Karten)

## 🤝 Beitragen

Verbesserungsvorschläge sind willkommen! Sie können:
- Issues für Fehler oder Verbesserungen erstellen
- Pull Requests mit Korrekturen oder Ergänzungen einreichen
- Die Kartenbedeutungen erweitern oder präzisieren

## 📄 Lizenz

Dieses Projekt steht unter der MIT-Lizenz.

### Quellen und Danksagungen

- **Kartenbilder**: [tarot-json](https://github.com/metabismuth/tarot-json) von metabismuth
- **Kartenbedeutungen**: Zusammengestellt aus verschiedenen deutschsprachigen Tarot-Quellen
- **API-Referenz**: [tarotapi.dev](https://tarotapi.dev/) für Kartennamen

## ❓ Häufige Fragen (FAQ)

### Die Bilder werden nicht angezeigt

Prüfen Sie:
1. Sind die Bilder in `/config/www/tarot/` vorhanden?
2. Haben die Dateien die richtigen Namen (z.B. `m00.jpg`, `w01.jpg`)?
3. Nach Änderungen im `www`-Ordner Home Assistant neu starten

### Die Karte wird nicht aktualisiert

1. Prüfen Sie die Logs unter **Einstellungen** → **System** → **Protokolle**
2. Stellen Sie sicher, dass alle YAML-Dateien korrekt eingebunden sind
3. Führen Sie das Script manuell aus zum Testen

### Ich möchte andere Kartendecks verwenden

1. Ersetzen Sie die Bilder in `/config/www/tarot/`
2. Passen Sie die `image`-Felder in `tarot_cards_de.json` an die neuen Dateinamen an
3. Optional: Ändern Sie auch die Bedeutungen nach Ihrem Kartendeck

## 🌟 Beispiele für erweiterte Nutzung

### Mehrfache Karten ziehen (z.B. 3-Karten-Lesung)

Erstellen Sie zusätzliche Input Selects und Sensoren für mehrere Kartenpositionen.

### Integration mit Benachrichtigungen

```yaml
automation:
  - alias: "Tarot Benachrichtigung"
    trigger:
      - platform: time
        at: "07:00:00"
    action:
      - service: script.tarot_karte_ziehen
      - service: notify.mobile_app
        data:
          title: "🔮 Ihre Tarot-Karte des Tages"
          message: >
            {{ states('input_select.tarot_karte_name') }}:
            {{ states('sensor.tarot_karte_bedeutung') }}
```

### Sprachausgabe

```yaml
action:
  - service: tts.google_translate_say
    data:
      message: >
        Ihre Karte des Tages ist {{ states('input_select.tarot_karte_name') }}.
        {{ states('sensor.tarot_karte_bedeutung') }}
```

## 💡 Tipps

- **Backup**: Sichern Sie regelmäßig Ihre Konfiguration
- **Testing**: Testen Sie Änderungen in einer Entwicklungsumgebung
- **Dokumentation**: Kommentieren Sie Ihre Anpassungen in den YAML-Dateien
- **Community**: Teilen Sie Ihre Erweiterungen mit der Community!

## 📞 Support

Bei Fragen oder Problemen:
1. Prüfen Sie die FAQ oben
2. Durchsuchen Sie die [Issues](https://github.com/IHR-USERNAME/ha-tarot-deutsch/issues)
3. Erstellen Sie ein neues Issue mit detaillierter Beschreibung

---

**Viel Freude mit Ihren Tarot-Lesungen! 🔮✨**
