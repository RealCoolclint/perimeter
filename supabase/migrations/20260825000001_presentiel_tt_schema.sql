-- Migration : Suivi Présentiel/TT (D33) — azimut Management d'équipe

create table if not exists rythme_config (
  id uuid primary key default gen_random_uuid(),
  date_debut date not null,
  jours_tt text[] not null,
  jours_presentiel text[] not null,
  personne text,
  created_at timestamptz not null default now()
);

create table if not exists presentiel_tt_evenements (
  id uuid primary key default gen_random_uuid(),
  personne text not null,
  date date not null,
  type text not null check (type in ('tt_exceptionnel', 'presentiel_exceptionnel')),
  source_monday_item_id text,
  source_monday_item_name text,
  created_at timestamptz not null default now(),
  unique (personne, date, type)
);

alter table rythme_config enable row level security;
alter table presentiel_tt_evenements enable row level security;

create policy "service_role only - rythme_config" on rythme_config
  for all using (auth.role() = 'service_role');
create policy "service_role only - presentiel_tt_evenements" on presentiel_tt_evenements
  for all using (auth.role() = 'service_role');

create index if not exists idx_presentiel_tt_personne on presentiel_tt_evenements(personne);
create index if not exists idx_presentiel_tt_date on presentiel_tt_evenements(date);

insert into rythme_config (date_debut, jours_tt, jours_presentiel)
values ('2025-10-13', array['lundi','mardi','vendredi'], array['mercredi','jeudi']);
