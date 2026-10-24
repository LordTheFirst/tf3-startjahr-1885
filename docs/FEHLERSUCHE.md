# Fehlersuche

| Problem | Prüfen / nächster Schritt |
| --- | --- |
| Menü zeigt nur 1900 | Im entpackten Komplettpaket `-Mode inspect` ausführen; richtige Spielinstallation prüfen. Begleitmod und Menüpatch werden zusammen benötigt. |
| Neues Spiel startet 1900 | Beim Anlegen ausdrücklich 1885 wählen. Ein vorhandener Spielstand wird nicht rückdatiert. |
| Depots/Wartung fehlen | Revision 5 aktivieren; alte Kopien und gegebenenfalls `staging_area` prüfen. |
| Kein Personenfahrzeug 1885 | Originaldaten bleiben erhalten. Erste Personen-Droschke: 1892. |
| Haltestelle lädt keine Güter | Kleine Straßenhaltestellen entladen Güter. Zum Abholen ein Universal-Güterterminal und passenden Güterwagen verwenden; Einzugsbereich und Produktion prüfen. |
| Skript von Windows blockiert | Skript prüfen, dann gegebenenfalls Dateieigenschaften → „Zulassen“. Im vollständig entpackten Paketordner ausführen. |
| Zugriff verweigert | Schreibrechte des Spielordners prüfen und das Spiel vollständig schließen. |
| Unsupported archive / content index | Spielversion oder Dateien weichen vom geprüften Build 40423 ab. Keine Prüfsummenprüfung umgehen; passende aktualisierte Patchfassung abwarten. |
| Temporäre Datei vorhanden | Das Werkzeug bricht absichtlich ab. Datei zur Prüfung behalten; nicht ungeprüft durch einen erneuten Patchlauf überschreiben. |
| Spielupdate setzt Menü zurück | Patch mit `inspect` prüfen. Die aktuelle Fassung akzeptiert nur die bekannten Dateien. |
| Absturz | Build, Modrevision, Startjahr, aktive Mods und letzte relevante Zeilen aus `stdout.txt` in einem Issue melden. |

Die Spielprotokolle liegen bei Steam üblicherweise unter `<Steam-Ordner>/userdata/<Konto-ID>/3493540/local/crash_dump/stdout.txt`. Falls kein aktuelles Protokoll dort liegt, den tatsächlichen Benutzerordner der eigenen Installation prüfen. Vor dem Hochladen persönliche Angaben entfernen.

Die ausführliche Installation und der Menü-Rückbau stehen in der [PDF](TF3_1885_Anleitung_DE.pdf) und [Textanleitung](../package/readme_de.md).
