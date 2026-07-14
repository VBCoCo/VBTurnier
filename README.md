# Volleyballturnier-Webseite 2.3.1

## Änderungen

- Navigation bleibt nach dem Speichern eines Turniers sichtbar.
- Nach erfolgreichem Speichern wird automatisch wieder die zuletzt geöffnete Ansicht angezeigt.
- In der Bearbeitungsmaske kann ein bestehendes Turnier gelöscht werden.
- Das Löschen verlangt zuerst eine Bestätigung und danach die Eingabe `LÖSCHEN`.

## Wichtig für Supabase

Die Datei `supabase_setup.sql` einmal im Supabase SQL Editor ausführen. Sie ergänzt die Funktion `delete_tournament`. Bestehende Turniere bleiben dabei erhalten.
