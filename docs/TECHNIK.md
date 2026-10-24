# Technischer Aufbau

## Zwei getrennte Komponenten

- `package/menu_patch.ps1` und `package/patch.json`: eigenständiges Windows-Werkzeug für die lokale Installation. Standardmodus ist `inspect`.
- `package/start_year_1885/`: Begleitmod mit technischer Revision 5. Keine Kalenderbefehle und kein externer Installer innerhalb des Modordners.

Das veröffentlichte Alpha-Paket und die hier hinterlegten Paketdateien sind bytegleich. Release-Version und technische Modrevision sind verschiedene Angaben: `1.0.0-alpha` und `5`.

## Menüpatch

Im archivierten Menüskript `gui/menu/new_game_react_util.tl` ersetzt der Patch bei gleichem Byteumfang:

```lua
local YearParams = {1900, 2020, 10}
```

durch:

```lua
local YearParams = {1885, 2020, 5 }
```

Die zwei zugehörigen ZIP-CRC-Felder werden ebenfalls angepasst. Der Patchplan enthält drei gezielte Byteänderungen. Er ist ausschließlich für die über SHA-256 geprüften Windows-Dateien aus Build 40423 bestimmt. Das Grundspielarchiv ist nicht Teil dieses Projekts.

Vor einer Änderung werden `base/_content.json`, Größe und SHA-256 von `base/content/gui.zip` geprüft. Der Spielprozess darf nicht laufen. Das Werkzeug verwendet eine Sicherung `gui.1885-original-<Hash-Präfix>.bak` neben dem Archiv und eine temporäre Nachbardatei `gui.1885-patch.tmp`. Eine vorhandene unbekannte Sicherung oder temporäre Datei wird nicht ungeprüft überschrieben. Der gewünschte Archivhash wird vor dem Dateitausch geprüft. Das geprüfte 1885-Archiv lässt sich auch in das byteidentische Original zurückverwandeln.

## Begleitmod

Die drei privaten KI-Pferdekutschen werden ab 1885 verfügbar. Die erste Vorlage von sieben Depot-/Wartungsgebäuden sowie die ersten Personen- und Universal-Güterstraßenterminals werden von 1900 auf 1885 erweitert. Die Anpassung erfolgt über die Modifikatoren in `content/traffic_support/`. Kaufbare Fahrzeugmodelle werden nicht vorgezogen. Native Vorlagenindizes und Modulerzeugung bleiben erhalten.

## Paket reproduzieren

Für die Veröffentlichung selbst ist Python nur auf Entwicklerseite erforderlich:

```text
python tools/build_package.py
python tools/build_package.py --check
```

Das erste Kommando erstellt `dist/TF3_1885_Start_Windows_Komplett_1.0.0-alpha.zip`, eine separat lesbare PDF und `SHA256SUMS.txt`. ZIP-Eintragsreihenfolge, Zeitstempel, Kompression und Dateiattribute entsprechen dem bestehenden Release. Das zweite Kommando prüft die erzeugten Dateien gegen die hinterlegten Release-Prüfsummen und erkennt zusätzliche Paketdateien. Es führt keinen Spieltest durch und verändert keine installierte Spieldatei.

## Geprüft und noch offen

Bereits offline geprüft wurden Mod-Code, native Verfügbarkeiten und Terminalvorlagen sowie das Patchwerkzeug mit Testdateien und einer Kopie des echten Spielarchivs. Diese spezialisierten Prüfungen nutzten die lokal installierten Spielressourcen und sind nicht Bestandteil dieses öffentlichen Pakets. Die GitHub-Prüfung verifiziert Paketinhalt, Metadaten und Prüfsummen.

Offen bleiben Engine-Spieltests für Bauplatzierung, Güterbe-/entladung, Wartung, Speichern/Laden und das Entfernen des Begleitmods vor 1900. Aus dem Offline-Teststand folgt keine bestätigte Spielstand- oder ModHub-Kompatibilität.
