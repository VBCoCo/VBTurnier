# Volleyball-Turnierverwaltung 2.0.0

## Neu: zwei Planungsarten

### Turnierdaten fix
Die bewährten und geprüften Spielpläne für 9, 10, 11, 12 und 13 Dreier-Teams bleiben unverändert verfügbar.

### Turnierdaten flexibel
Frei einstellbar sind:
- Turniername und Datum
- Anzahl Teams (2 bis 40)
- Teamgröße (1 bis 6 Spieler)
- Teams je Spielseite (1 bis 3)
- gewünschte Spiele je Team
- Anzahl und Namen der Spielfelder
- Turnierstart
- Spielzeit und Wechselpause
- Länge und Position der Turnierpause
- Uhrzeit der Siegerehrung
- optionale Spielernamen und Finalrunde

Der Generator akzeptiert einen Plan nur, wenn alle Teams exakt gleich viele Spiele erhalten. Partnerwiederholungen und häufige Gegner werden bei der Berechnung gewichtet und soweit möglich vermieden. Die Fairnessseite kontrolliert den erzeugten Plan anschließend erneut.

## Aktualisierung auf GitHub Pages
Alle Dateien dieses Ordners in das vorhandene Repository kopieren und die alten Dateien ersetzen. Eine neue Supabase-SQL-Anpassung ist nicht erforderlich, weil die zusätzlichen Einstellungen im bestehenden JSON-Datensatz des Turniers gespeichert werden.

Version: 2.0.0  
Build: 2026.07.14-15
