# Volleyball-Turnierverwaltung 1.9.3

Korrekturen:
- Öffentliche Anzeige zeigt keinen Verwaltungsbereich mehr.
- Mittagspause beträgt exakt 45 Minuten.
- Finalrunde erscheint nach Aktivierung im Spielplan und in der Ergebniserfassung.
- Der 12-Team-Spielplan wurde neu angeordnet: Runde 6 ist vollständig belegt; der mathematisch notwendige freie Feldslot liegt in Runde 11.

Keine neue Supabase-SQL-Anpassung erforderlich. Alle Dateien auf GitHub Pages ersetzen.


## Änderung 1.9.3
- Beim 12-Team-Plan ist Runde 6 auf Sand und Rasen belegt.
- Der einzige freie Feldslot liegt in Runde 11 auf dem Sandplatz und ist als Nachholspiel-Puffer markiert.
- Cache-Busting und Network-first-Service-Worker verhindern das Laden eines alten Spielplans.


## Änderung 1.9.3
- Mittagspause als grauer Balken mit Uhrzeit im Spielplan.
- Die 45-minütige Mittagspause wird in den Uhrzeiten berücksichtigt.
- Bei 12 Teams wird Runde 11 auf Sand gespielt; Rasen 1 bleibt als Nachholspiel-Puffer frei.
