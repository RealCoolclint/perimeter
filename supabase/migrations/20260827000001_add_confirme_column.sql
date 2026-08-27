-- Migration : ajout de la colonne confirme (D37) — dette versionnée a posteriori
-- Documente une colonne déjà appliquée en production le 25 août 2026 (D37),
-- jamais versionnée dans le repo jusqu'ici. Idempotente : sans effet si déjà présente.

alter table presentiel_tt_evenements
  add column if not exists confirme boolean not null default false;

comment on column presentiel_tt_evenements.confirme is
  'true = détection vérifiée (roster identifié) ; false = attribution par défaut à Martin faute d''info, à affiner par croisement mail/Teams/calendrier (D37)';
