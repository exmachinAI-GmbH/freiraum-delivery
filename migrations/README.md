# migrations/ · versionierte Migrationen

**Noch leer.** Erste Migration bei Baustart: Übernahme von `Migration_260801_tenant.sql`
aus der Konzeptfabrik (`arbeit/`) — vier Spalten, zwei Bedingungen, vier Negativfälle.

Regeln: Das v2.9-DDL ist Ground Truth. Jede Migration ist versioniert und führt ihre
Negativfälle mit; **alle Negativfälle müssen scheitern**, bevor die Migration als
angewendet gilt. Anwendung nur in der Datenbank des jeweiligen Pilot-Anlaufs.
