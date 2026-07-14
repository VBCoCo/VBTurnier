# Volleyball-Turnierverwaltung – Version 1.3.0

## Veröffentlichung auf GitHub Pages

Den gesamten Inhalt dieses Ordners in das bestehende GitHub-Repository hochladen und die vorhandenen Dateien ersetzen. Danach in der App über das Info-Symbol prüfen:

- Version: 1.3.0
- Build: 2026.07.14-1

## Turnier laden

1. Auf der Startseite den Turniercode eingeben.
2. **Turnier laden** drücken.
3. Der gespeicherte Turniername, das Datum, die Teamzahl, Teams und Ergebnisse werden aus Supabase geladen.

## Turnier speichern

1. Turniername, Datum, Teamzahl und Turniercode eintragen oder ändern.
2. **Turnier speichern** drücken.
3. Die Daten werden lokal und in Supabase gespeichert; anschließend öffnet sich die Teamseite.

Die Schaltfläche **Nur lokal speichern & Teams öffnen** speichert nur auf dem gerade verwendeten Gerät.

## Zeitmodell

- 9 Teams: 30 Minuten Spielzeit, 5 Minuten Wechselpause
- 10 bis 13 Teams: 20 Minuten Spielzeit, 10 Minuten Wechselpause

## Supabase

Die bestehende `config.js` mit Supabase-URL und öffentlichem Anon-Key unverändert weiterverwenden. Falls die Datenbank noch nicht eingerichtet ist, `supabase_setup.sql` einmal im SQL-Editor des Supabase-Projekts ausführen.
