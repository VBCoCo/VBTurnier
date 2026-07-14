# Volleyball-Turnierverwaltung – Version 1.7.0

## Neu
- TTC-Geltendorf-Logo und blaues Vereinsdesign
- Anzeige-Modus ohne Passwort: Ergebnisseingabe, Partner und Fairness werden ausgeblendet
- Ergebnisse werden direkt im Spielplan angezeigt
- Teamansicht ist im Anzeige-Modus schreibgeschützt
- Version/Build: 1.7.0 / 2026.07.14-7

# Volleyball-Turnierverwaltung 1.4.0

## Neue Funktionen

- Auswahlmenü mit allen vorhandenen Cloud-Turnieren
- Turniere können ohne Passwort geladen und angesehen werden
- Anlegen und Speichern ist nur mit dem Turnierpasswort möglich
- Das Passwort wird nicht in der Datenbank im Klartext gespeichert
- Das eingegebene Passwort bleibt nur für die aktuelle Browser-Sitzung erhalten

## Update auf GitHub Pages

Alle Dateien dieses Ordners in das bestehende GitHub-Repository hochladen und die bisherigen Dateien ersetzen.

## Supabase unbedingt aktualisieren

1. Supabase öffnen.
2. Zum **SQL Editor** wechseln.
3. Den vollständigen Inhalt von `supabase_setup.sql` ausführen.
4. `config.js` mit der vorhandenen Supabase-URL und dem Anon-Key beibehalten.

Die SQL-Datei sperrt direkte Tabellenänderungen und stellt nur kontrollierte Funktionen bereit. Das Bearbeitungspasswort wird mit `pgcrypto` gehasht.

## Bestehende Turniere

Alte Turniere ohne Passwort erscheinen weiter im Auswahlmenü. Beim ersten Speichern wird das eingegebene Passwort als Schutz gesetzt. Danach kann nur noch mit diesem Passwort gespeichert werden.

## Bedienung

- **Liste aktualisieren:** lädt alle vorhandenen Turniere.
- **Ausgewähltes Turnier laden:** öffnet den gemeinsamen Stand. Ohne Passwort nur lesbar.
- **Neues Turnier anlegen:** verwendet Turniername, neuen Code und Passwort. Das Passwort muss mindestens sechs Zeichen lang sein.
- **Änderungen speichern:** überschreibt den Cloud-Stand nur mit dem korrekten Passwort.

Hinweis: Team- und Ergebnisänderungen werden nach erfolgreicher Freischaltung zusätzlich automatisch synchronisiert. Der ausdrückliche Speicherbutton bleibt trotzdem verfügbar.


## Neu in Version 1.5.0

- Im Turnier-Auswahlmenü stehen jetzt Turniername und tatsächliches Turnierdatum.
- Das bisher angezeigte Aktualisierungsdatum wird nicht mehr als Turnierdatum verwendet.
- Beim Anlegen eines neuen Turniers sind Turniername und Datum Pflicht und werden in der Cloud gespeichert.
- Nach dem Hochladen muss `supabase_setup.sql` erneut im Supabase SQL Editor ausgeführt werden.


## Neu in Version 1.6.1

- Eingabefelder verlieren während der Bearbeitung nicht mehr durch die Cloud-Aktualisierung den Fokus.
- Lokale Änderungen werden nicht mehr durch einen älteren Cloud-Stand überschrieben, solange sie noch gespeichert werden.
- Teamnamen, Spielernamen und mehrstellige Ergebnisse werden mit jedem Tastendruck lokal übernommen und anschließend im Hintergrund synchronisiert.
- Cloud-Abfragen pausieren automatisch, solange ein Eingabefeld aktiv ist.


## Version 1.6.1
- Race-Condition zwischen laufender Cloud-Speicherung und neuen Tastendrücken behoben.
- Neuere Eingaben können nicht mehr von einer älteren Speicherantwort als gespeichert markiert werden.
- Cloud-Abfrage pausiert beim Fokus und kurz nach dem Verlassen eines Eingabefeldes.
- Falls während des Speicherns weitergeschrieben wird, folgt automatisch ein weiterer Speichervorgang.


## Version 1.6.2

- Bereits vor der Eingabe gestartete Cloud-Abfragen werden bei jeder neuen lokalen Aktion ungültig.
- Eine alte Cloud-Antwort kann Ergebnis- oder Teamfelder nicht mehr auf einen vorherigen Wert zurücksetzen.
- Cloud-Aktualisierungen werden erst nach mindestens fünf Sekunden ohne lokale Änderung übernommen.


## Version 1.7.1
- Weiße Kopfzeile mit Vereinslogo und TTC-Blau.
- Navigation bleibt auf der Startseite verborgen, bis ein Turnier geöffnet oder neu angelegt wurde.
- Lesemodus blendet Ergebnisse, Partner und Fairness vollständig aus.
- Eingaben sind im Lesemodus gesperrt.
- Bearbeitungsmodus wird erst nach erfolgreicher Passwortprüfung freigeschaltet.
