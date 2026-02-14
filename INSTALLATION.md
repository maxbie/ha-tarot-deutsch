# Detaillierte Installations- und Setup-Anleitung

Diese Anleitung führt Sie Schritt für Schritt durch die Installation der Tarot-Integration für Home Assistant.

## Voraussetzungen

- Home Assistant Core, Supervised oder OS (Version 2023.1 oder neuer empfohlen)
- Zugriff auf das Home Assistant Konfigurationsverzeichnis
- Grundlegende Kenntnisse in YAML
- (Optional) Git für das Herunterladen der Kartenbilder

## Schritt 1: Repository herunterladen

### Option A: Mit Git

```bash
cd /tmp
git clone https://github.com/IHR-USERNAME/ha-tarot-deutsch.git
cd ha-tarot-deutsch
```

### Option B: Als ZIP

1. Laden Sie das Repository als ZIP-Datei herunter
2. Entpacken Sie die Datei in einen temporären Ordner

## Schritt 2: Dateien kopieren

### JSON-Datei

```bash
# Kopieren Sie die Kartendaten ins Home Assistant config-Verzeichnis
cp tarot_cards_de.json /config/
```

### YAML-Konfigurationsdateien

```bash
# Erstellen Sie den tarot-Ordner
mkdir -p /config/tarot

# Kopieren Sie alle YAML-Dateien
cp tarot/*.yaml /config/tarot/
```

## Schritt 3: Kartenbilder installieren

Die Tarot-Bilder müssen separat heruntergeladen werden.

### Option A: Automatisch mit Git

```bash
# Klonen Sie das Bilder-Repository
git clone --depth 1 https://github.com/metabismuth/tarot-json.git /tmp/tarot-images

# Erstellen Sie den Zielordner
mkdir -p /config/www/tarot

# Kopieren Sie die Bilder
cp /tmp/tarot-images/cards/* /config/www/tarot/

# Aufräumen
rm -rf /tmp/tarot-images
```

### Option B: Manuell

1. Besuchen Sie: https://github.com/metabismuth/tarot-json
2. Laden Sie den gesamten `cards`-Ordner herunter
3. Kopieren Sie alle Bilddateien nach `/config/www/tarot/`

### Bilder überprüfen

Nach der Installation sollten Sie folgende Dateien haben:

```
/config/www/tarot/
├── m00.jpg  (Der Narr)
├── m01.jpg  (Der Magier)
├── ...
├── m21.jpg  (Die Welt)
├── w01.jpg  (As der Stäbe)
├── ...
├── c01.jpg  (As der Kelche)
├── ...
├── s01.jpg  (As der Schwerter)
├── ...
└── p01.jpg  (As der Münzen)
```

Insgesamt sollten 78 Bilddateien vorhanden sein.

## Schritt 4: Home Assistant Konfiguration

### configuration.yaml bearbeiten

Öffnen Sie Ihre `/config/configuration.yaml` und fügen Sie folgende Zeilen hinzu:

```yaml
# Tarot Integration
input_select: !include tarot/input_select.yaml
sensor: !include tarot/sensor.yaml
script: !include tarot/scripts.yaml
automation: !include tarot/automations.yaml
```

**WICHTIG:** Wenn Sie bereits `input_select:`, `sensor:`, `script:` oder `automation:` in Ihrer configuration.yaml haben, müssen Sie diese anders einbinden. Siehe Abschnitt "Erweiterte Konfiguration" unten.

### Konfiguration überprüfen

1. Gehen Sie zu **Einstellungen** → **System** → **Konfigurationsprüfung**
2. Klicken Sie auf **Konfiguration prüfen**
3. Beheben Sie eventuelle Fehler

## Schritt 5: Home Assistant neu starten

1. Gehen Sie zu **Einstellungen** → **System**
2. Klicken Sie auf **Neu starten**
3. Warten Sie, bis Home Assistant vollständig neu gestartet ist

## Schritt 6: Erste Karte ziehen

Nach dem Neustart können Sie das System testen:

1. Gehen Sie zu **Entwicklerwerkzeuge** → **Dienste**
2. Suchen Sie nach "Tarot Karte ziehen"
3. Wählen Sie `script.tarot_karte_ziehen`
4. Klicken Sie auf **Dienst aufrufen**

## Schritt 7: Dashboard-Karte hinzufügen

### Einfache Markdown-Karte

1. Öffnen Sie Ihr Dashboard
2. Klicken Sie auf die drei Punkte oben rechts → **Dashboard bearbeiten**
3. Klicken Sie auf **+ Karte hinzufügen**
4. Wählen Sie **Markdown**
5. Fügen Sie folgenden Code ein:

```yaml
type: markdown
content: |
  ## 🔮 Tägliche Tarot-Karte
  
  **{{ states('input_select.tarot_karte_name') }}**
  
  ![Tarot]({{ states('sensor.tarot_karte_bild') }})
  
  {{ states('sensor.tarot_karte_bedeutung') }}
```

6. Klicken Sie auf **Speichern**

### Weitere Karten-Beispiele

Schauen Sie in `lovelace_cards.yaml` für weitere Dashboard-Karten-Beispiele.

## Erweiterte Konfiguration

### Bestehende Konfigurationen zusammenführen

Wenn Sie bereits eigene `input_select`, `sensor`, etc. Einträge haben:

#### Option 1: Direktes Einfügen

Kopieren Sie den Inhalt der YAML-Dateien direkt in die entsprechenden Abschnitte Ihrer configuration.yaml.

#### Option 2: Mehrere Includes

```yaml
# Bestehende Includes
input_select: !include input_select.yaml

# Neue Struktur
input_select:
  - !include input_select.yaml
  - !include tarot/input_select.yaml
```

#### Option 3: Merge-Includes

Erstellen Sie eine `input_select.yaml` im Hauptverzeichnis:

```yaml
# Ihre bestehenden Input Selects
mein_input:
  ...

# Tarot Input Selects
!include tarot/input_select.yaml
```

### Automatisierung anpassen

Die Standardzeit für die tägliche Karte ist 07:00 Uhr. Ändern Sie dies in `/config/tarot/automations.yaml`:

```yaml
trigger:
  - platform: time
    at: "09:30:00"  # Ihre gewünschte Zeit
```

### Benachrichtigungen aktivieren

Entfernen Sie in `/config/tarot/automations.yaml` die Kommentare (#) vor der Benachrichtigungsautomatisierung und passen Sie den Benachrichtigungsdienst an:

```yaml
- id: tarot_benachrichtigung
  alias: "Tarot-Karte Benachrichtigung"
  ...
  action:
    - service: notify.mobile_app_mein_handy  # Anpassen!
      data:
        ...
```

## Fehlerbehebung

### Bilder werden nicht angezeigt

**Problem:** Die Karten-Bilder erscheinen nicht im Dashboard.

**Lösungen:**
1. Prüfen Sie, ob die Bilder in `/config/www/tarot/` vorhanden sind
2. Starten Sie Home Assistant nach dem Kopieren der Bilder neu
3. Prüfen Sie die Dateinamen (sie müssen genau mit der JSON übereinstimmen)
4. Prüfen Sie die Dateiberechtigungen

### Sensoren zeigen "unknown" oder "unavailable"

**Problem:** Die Template-Sensoren zeigen keinen Wert an.

**Lösungen:**
1. Prüfen Sie, ob `sensor.tarot_karten_json` existiert und Daten hat
2. Schauen Sie in die Logs: **Einstellungen** → **System** → **Protokolle**
3. Prüfen Sie, ob die JSON-Datei korrekt formatiert ist
4. Stellen Sie sicher, dass der Pfad `/config/tarot_cards_de.json` korrekt ist

### Script existiert nicht

**Problem:** `script.tarot_karte_ziehen` wird nicht gefunden.

**Lösungen:**
1. Prüfen Sie, ob `script:` korrekt in configuration.yaml eingebunden ist
2. Überprüfen Sie die YAML-Syntax in `tarot/scripts.yaml`
3. Starten Sie Home Assistant neu
4. Prüfen Sie die Logs auf Fehler

### Automatisierung funktioniert nicht

**Problem:** Die tägliche Karte wird nicht automatisch gezogen.

**Lösungen:**
1. Prüfen Sie, ob die Automatisierung aktiviert ist
2. Gehen Sie zu **Einstellungen** → **Automatisierungen & Szenen**
3. Suchen Sie nach "Tägliche Tarot-Karte"
4. Prüfen Sie den Status und die Logs

### YAML-Syntax-Fehler

**Problem:** "Invalid config" nach dem Neustart.

**Lösungen:**
1. Nutzen Sie die Konfigurationsprüfung vor dem Neustart
2. Prüfen Sie die Einrückungen (YAML verwendet Leerzeichen, keine Tabs)
3. Achten Sie auf Sonderzeichen in Strings
4. Kopieren Sie die Fehler aus den Logs und suchen Sie nach der Zeile

## Backup erstellen

Vor größeren Änderungen sollten Sie immer ein Backup erstellen:

1. Gehen Sie zu **Einstellungen** → **System** → **Sicherungen**
2. Klicken Sie auf **Sicherung erstellen**
3. Warten Sie, bis die Sicherung abgeschlossen ist

## Deinstallation

Falls Sie die Tarot-Integration entfernen möchten:

```bash
# Konfigurationsdateien entfernen
rm -rf /config/tarot/
rm /config/tarot_cards_de.json

# Bilder entfernen (optional)
rm -rf /config/www/tarot/
```

Entfernen Sie dann die entsprechenden Zeilen aus Ihrer `configuration.yaml` und starten Sie Home Assistant neu.

## Support

Bei weiteren Fragen:

1. Prüfen Sie die [FAQ in der README](README.md#-häufige-fragen-faq)
2. Schauen Sie in die [Issues](../../issues)
3. Erstellen Sie ein neues Issue mit detaillierter Beschreibung

---

**Viel Erfolg bei der Installation! 🔮**
