# Volleyballturnier-Webseite 2.4.1

## Änderungen

- Navigation bleibt nach dem Speichern eines Turniers sichtbar.
- Nach erfolgreichem Speichern wird automatisch wieder die zuletzt geöffnete Ansicht angezeigt.
- In der Bearbeitungsmaske kann ein bestehendes Turnier gelöscht werden.
- Das Löschen verlangt zuerst eine Bestätigung und danach die Eingabe `LÖSCHEN`.

## Wichtig für Supabase

Die Datei `supabase_setup.sql` einmal im Supabase SQL Editor ausführen. Sie ergänzt die Funktion `delete_tournament`. Bestehende Turniere bleiben dabei erhalten.


## Neu in 2.4.1

Im flexiblen Generator kann die exakte Gleichverteilung der Platzarten priorisiert werden. In diesem Modus darf der Plan zusätzliche Runden und freie Felder enthalten. Die Zeitprüfung nennt die tatsächliche Endzeit und gegebenenfalls die zusätzlich benötigten Minuten bis zur Siegerehrung.
