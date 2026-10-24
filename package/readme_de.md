# 1885 Starthilfe 1.0.0-alpha – Windows-Komplettpaket

Die Schritt-für-Schritt-Anleitung mit schematischen Abbildungen liegt als **anleitung_de.pdf** im Paket. Sie erklärt Menüpatch, Modinstallation, Spielstart und Rückbau. Die folgenden Texte dienen zusätzlich als kopierbare Kurzreferenz.

Erstellt von Lord. Vibecoding by Codex. Enthält den Begleitmod, Revision 5, und ein separates Menü-Patchwerkzeug für Windows. Kein Python erforderlich. Das Paket enthält weder die Grundspiel-`gui.zip` noch Modelle oder Texturen aus dem Spiel.

## Installation

1. Dieses ZIP vollständig in einen eigenen Ordner entpacken. TF3 vollständig schließen.
2. Den Spielinstallationsordner ermitteln. Bei Steam: Spiel → Verwalten → Lokale Dateien durchsuchen. Gemeint ist der Ordner mit `TransportFever3.exe`, nicht der Benutzerordner.
3. In diesem entpackten Paketordner PowerShell öffnen und folgenden Befehl ausführen; den Beispielpfad durch den eigenen Spielinstallationsordner ersetzen:

```powershell
powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -File .\menu_patch.ps1 -Mode apply -GamePath "C:\Program Files (x86)\Steam\steamapps\common\Transport Fever 3"
```

Die Ausführungsrichtlinie gilt dabei nur für diesen PowerShell-Prozess. Falls Windows das heruntergeladene Skript als Internetdatei blockiert, nach Prüfung des Skripts dessen Dateieigenschaften öffnen und gegebenenfalls „Zulassen“ auswählen. Es werden keine dauerhaften Sicherheitseinstellungen geändert. Ein schreibgeschützter Spielordner benötigt passende Schreibrechte.

4. Den enthaltenen Ordner `start_year_1885` in den Benutzer-Modordner von TF3 kopieren. Bei Steam: `<Steam-Ordner>/userdata/<Konto-ID>/3493540/local/mods/`. Neue technische Mod-ID: `start_year_1885`. Die bisherige Begleitmod-Fassung deaktivieren und ihren alten Ordner aus dem Modbereich herausnehmen. Diese Fassung einmal neu aktivieren; keine parallelen Kopien anlegen. Eine Entwicklerversion in `staging_area` hat Vorrang vor manuell installierten oder abonnierten Fassungen: diese gegebenenfalls ebenfalls aktualisieren oder aus dem Staging-Bereich herausnehmen.
5. Spiel starten, „1885 Starthilfe“, Revision 5, aktivieren und ein neues freies Spiel mit ausdrücklich ausgewähltem Startjahr 1885 erstellen. Einen alten „Start Year 1850“-Kalenderprototyp deaktiviert lassen.

Der Mod schaltet private KI-Kutschen, frühe Depots, Wartungsgebäude und frühe Straßenterminals frei. Kaufbare Fahrzeuge behalten ihre Originalwerte und -jahre. Die erste Personen-Droschke kommt weiterhin erst 1892. Kleine Straßenhaltestellen können Güter regulär nur entladen; zum Abholen ein Universal-Güterterminal bauen.

## Prüfung und Rückbau

Nur prüfen: denselben Befehl mit `-Mode inspect` ausführen. Standard ohne Modus ist ebenfalls eine reine Prüfung.

Menüänderung entfernen: TF3 schließen und denselben Befehl mit `-Mode restore` ausführen. Das ursprüngliche 1900-Menü wird wiederhergestellt. Dies entfernt weder den Begleitmod noch verändert es bestehende Spielstände. Das Entfernen des Begleitmods aus einem Spiel vor 1900 ist ungeprüft; vorhandene Testspielstände separat sichern.

Das Werkzeug akzeptiert ausschließlich die in `patch.json` genannten Prüfsummen der untersuchten Windows-Spielversion (Build 40423): Originalmenü oder geprüfter 1885-Patch. Andere Versionen und anderweitig veränderte Dateien werden abgewiesen. Die Sicherung liegt neben `gui.zip` als `gui.1885-original-<Prüfsumme>.bak`; sie wird nie ungeprüft überschrieben. Auch aus dem geprüften 1885-Archiv lässt sich das byteidentische Original rekonstruieren. Ein übrig gebliebenes `gui.1885-patch.tmp` führt zum Abbruch und bleibt zur Prüfung erhalten.

Spielupdates und eine Steam-Dateiprüfung können die Menüänderung zurücksetzen. Dann erst die Spielversion prüfen; dieses Werkzeug überschreibt keine unbekannte Version. Bei neuen Spielversionen muss der Patch neu geprüft und bereitgestellt werden. Konsolen und andere Betriebssysteme sind durch dieses Komplettpaket nicht abgedeckt.

## Teststand

Der Nutzer berichtet, dass der Start vor 1900 mit dem Privatverkehrsfix zu funktionieren scheint. Mod-Code, native Verfügbarkeiten, Terminal-Vorlagen und Fahrzeugdaten wurden offline geprüft. Das externe Werkzeug wurde mit Testdateien auf Installation, wiederholte Anwendung, Wiederherstellung und Abbruchbedingungen geprüft; außerdem wurde ein Durchlauf an einer Kopie des echten Grundspielarchivs geprüft. Ein Engine-Spieltest des vollständigen Pakets einschließlich Be-/Entladen, Wartung und Speichern/Laden steht aus. Keine bestätigte ModHub-Freigabe oder Zusicherung zur Spielstandkompatibilität.

## Veröffentlichung

Dieses Komplettpaket ist für einen externen Windows-Download vorgesehen. Es ist **kein ModHub-Uploadpaket**: Shellskripte und externe Programme sind dort laut offiziellen Vorgaben nicht erlaubt.

Für den ModHub ausschließlich den separaten Modordner `start_year_1885` verwenden. Den Mod zuerst in der Entwickler-Staging-Area im Spiel validieren. In der Beschreibung deutlich auf den zusätzlichen Windows-Menüpatch verweisen und die tatsächliche Downloadadresse ergänzen. Die getrennte Datei `TF3_1885_Starthilfe_ModHub_1.0.0-alpha.zip` enthält nur diesen Mod, keinen Installer. Auch deren Plattformfreigabe ist noch nicht bestätigt. Ein Abonnement allein aktiviert keine Menüänderung.

Geeigneter Ablauf: Komplettpaket extern veröffentlichen, dessen echte Downloadadresse in die englische/deutsche Modbeschreibung aufnehmen, Begleitmod validieren und im ModHub unter „Meine Mods“ hochladen. Externe Dateien niemals in den Modordner des ModHub-Pakets kopieren.

Quellen:

- [ModHub-Anforderungen](https://wiki.transportfever3.com/doku.php?id=modding:general:guidelines)
- [Mod veröffentlichen](https://wiki.transportfever3.com/doku.php?id=modding:general:publishing)
- [Mod-Ladefunktionen](https://wiki.transportfever3.com/doku.php?id=modding:general:modscripts)
- [Spiel- und Benutzerordner](https://wiki.transportfever3.com/doku.php?id=gamemanual:installation:gamefilelocations)

Keine Lizenz festgelegt. Enthält eigene Skripte und gezielte Byteänderungen; die Dateien des installierten Urban-Games-Grundspiels werden nur lokal verarbeitet.
