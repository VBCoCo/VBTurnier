# Volleyball-Turnierverwaltung

## GitHub Pages
Alle Dateien dieses Ordners in das GitHub-Repository hochladen. Danach GitHub Pages fuer den Branch `main` und den Ordner `/root` aktivieren.

## Gemeinsamer Datenstand auf mehreren Geraeten
GitHub Pages ist statisch und kann selbst keine Turnierdaten speichern. Die App unterstuetzt deshalb optional Supabase als kleinen Cloud-Datenspeicher.

1. Kostenloses Projekt auf Supabase anlegen.
2. Im SQL Editor den Inhalt von `supabase_setup.sql` ausfuehren.
3. In Supabase unter Project Settings / API die Project URL und den anon public key kopieren.
4. In `config.js` beide Werte eintragen:

```js
window.TURNIER_CLOUD_CONFIG = {
  supabaseUrl: 'https://IHR-PROJEKT.supabase.co',
  supabaseAnonKey: 'IHR-ANON-KEY'
};
```

5. Geaenderte `config.js` wieder zu GitHub hochladen.
6. In der App auf allen Geraeten denselben schwer erratbaren Turniercode eingeben und `Cloud verbinden / laden` waehlen.

Die App speichert weiterhin zusaetzlich lokal. Cloud-Aenderungen werden automatisch gespeichert und etwa alle 5 Sekunden auf anderen geoeffneten Geraeten geladen.

## Hinweise
- Spielernamen sind optional und koennen auf der Startseite ein- oder ausgeblendet werden.
- Ein Turniercode ist kein echtes Benutzerkonto. Verwenden Sie daher einen nicht leicht erratbaren Code und keine sensiblen personenbezogenen Daten.
- Fuer eine spaetere oeffentliche Nutzung waeren Benutzeranmeldung und strengere Zugriffsregeln sinnvoll.
