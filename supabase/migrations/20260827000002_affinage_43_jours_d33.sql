-- Migration : affinage des 43 jours non confirmés (chantier post-D39)
-- Cadrage acté en session du 27 août 2026 :
--   1. Jours sans présence physique réelle (SOLO REDAC / TOUT IMAGE) : supprimés
--   2. Personnes hors roster actuel (ex-alternantes) : lignes supprimées
--   3. Jours multi-personnes : éclatés en une ligne par personne
--   4. "TOUTE L'EQUIPE" = les 5 personnes suivies + Martin Pavloff (6 au total)

-- 9 suppressions (pas de présentiel réel ou hors roster)
delete from presentiel_tt_evenements where id in (
  'b8237201-258b-4d1d-acd3-80d85cbfc503', -- BTS_ORANGE_ROADSHOW
  '575454b9-48cf-40e8-a6ea-5b3e48e46e99', -- SCH - ORELSAN
  '71f327de-e59f-422b-82c1-e71865293058', -- SCH -JUNKET MARSUPILAMI
  '75041c65-eee4-42cf-a602-46aa4fc66d8d', -- MT_LA GUERRE_AVIS/CRAINTE
  'b2fd73b9-9ec7-4db9-aa7b-f3e61657d8ea', -- SCH_JUNKET_CASTING_JUSTE_UNE_ILLUSION
  '6aeeb86d-452e-4e8b-b47c-97c4503a6e94', -- ADLE - Sortie concours Ingé Polytech
  '2b641d08-04e5-4e34-9520-deb66c2461a8', -- PROMO_5_RAISONS_POUR_X9
  '9934bbf3-418b-40b1-a026-1d1ff37586c0', -- ADLE_MT_NOSTALGIE_Résultat du bac
  '5a57ee25-7232-4970-8d55-1bd24d7e6b69' -- LA_LISTE_GSK
);

-- 33 confirmations (personne + confirme = true, id existant conservé)
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = '33a11df0-cf0c-4510-bcdc-43d595d93703'; -- Interro - Cenzo
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = 'b36f3483-8982-48f5-a7dd-03fcd56889cd'; -- SCH Anis Rhali
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = '92b647a9-c3d5-4fd5-98f2-697bf7f089d6'; -- CDLE - NEGOCIER SALAIRE 1er EMPLOI
update presentiel_tt_evenements set personne = 'Thomas Clicteur', confirme = true where id = '718627ec-b603-4516-b46c-bb33c39d994d'; -- SIG _ AUDREY T''explique (capsule 1)
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = 'dd14c33d-2173-4b2d-9ef9-4c6b4bfd4acf'; -- CDLE - SANTE MENTALE
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = '87180702-933e-4a8a-9e71-0c21d5d542bc'; -- DDLE_Diplome Universitaire
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = '438e6ffe-79ff-4c13-a589-c94462024ecb'; -- ITW - FJAF INTERVIEW
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = 'ab1f3b7d-37ba-4012-ba11-d6369306ce7e'; -- DDLE_CHIFFRES L1
update presentiel_tt_evenements set personne = 'Thomas Clicteur', confirme = true where id = '3d2aa7a3-7a4c-4396-b5b6-aabcf445e379'; -- FJAF CQTONJOB
update presentiel_tt_evenements set personne = 'Antoine Paley', confirme = true where id = 'ac92791a-4f4b-4f65-a86a-bc507d3fb09d'; -- CQUOI - JUNGELI P2
update presentiel_tt_evenements set personne = 'Thomas Clicteur', confirme = true where id = 'e0207d80-0889-4317-8f6e-6d0afaf88b7d'; -- CQUOI - OPCO2i
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = 'daa72b4e-ac8d-4bb2-a6b3-239a4510401a'; -- RECIT - ELEVE CHINOIS BURNOUT
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = '04810fb4-9d4d-4b36-b781-0f49841f984f'; -- INTERRO METIER POLICE
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = 'f3397282-9b97-4723-bf93-ec4faae48a30'; -- GES - EIML
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = 'c8be5199-2bbe-42cc-9b6a-78d4578b512c'; -- GES - EFET CREA
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = 'e4537156-1344-49cf-963e-0760428212f8'; -- GES - ESGI
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = 'de11e730-c957-4eaf-8dea-2c8041d56244'; -- RECIT - PUNK DES MATHS
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = '3889a90d-f481-4940-b859-31c80dc31a32'; -- ITR - ESPI
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = 'c6ce557c-5447-432b-a14f-740ede1529cf'; -- GES - ESIS
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = '64196f3d-2bf0-46d4-b122-db3e1c054a15'; -- GES - ICAN
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = 'cf1d79c8-dee9-4395-b18f-1041342a9830'; -- GES - EFAB
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = '244cbb24-921f-4847-b83c-8631cd4d0355'; -- ITW - THAIS ALLESSEDRIN
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = 'ce1c7d8a-7be8-4ade-9530-6d6091a9c02d'; -- IONIS - ISEFAC -VIDEO 6
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = 'c434fcc8-b0d0-4d2c-af53-63cd51293d79'; -- PROMO _ XP VOEUX 1
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = '1f17e4fc-8fcd-4aad-aef9-dba8274f6e84'; -- ITW_DRH MS
update presentiel_tt_evenements set personne = 'Martin Pavloff', confirme = true where id = 'ae5c07a0-a4b0-4f6a-93f0-d6a6c8765115'; -- GES - ECITV
update presentiel_tt_evenements set personne = 'Thomas Clicteur', confirme = true where id = '81b11e12-76fd-440f-9395-7392084880fc'; -- CORRIGE BAC MATHS ANTICIPES hors SPE
update presentiel_tt_evenements set personne = 'Thomas Clicteur', confirme = true where id = '229361bf-d6b4-407f-b8be-20a1ef6589a3'; -- CORRIGE BAC Techno Philo
update presentiel_tt_evenements set personne = 'Thomas Clicteur', confirme = true where id = 'f46c72b7-516c-4561-8167-47d3147f4ff7'; -- CORRIGE BAC SPE J1_SES_4/5
update presentiel_tt_evenements set personne = 'Thomas Clicteur', confirme = true where id = '0f372d8e-e67d-481e-a3f9-ef4c4e35be30'; -- CORRIGE BREVET FRANCAIS
update presentiel_tt_evenements set personne = 'Thomas Clicteur', confirme = true where id = '73c98fcd-512f-4c8b-ad68-0e2312b64fa4'; -- CORRIGE BREVET Histoire Géo
update presentiel_tt_evenements set personne = 'Thomas Clicteur', confirme = true where id = '1cc2f01b-ccda-4e96-96cb-d938396e0d6f'; -- CORRIGE BREVET Maths
update presentiel_tt_evenements set personne = 'Antoine Paley', confirme = true where id = '67c2cbcf-aa66-46db-96c7-b4d54d80f889'; -- CQUOI_FJAF

-- 31 nouvelles lignes (personnes supplémentaires sur jours multi-personnes)
insert into presentiel_tt_evenements (personne, date, type, source_monday_item_id, source_monday_item_name, confirme) values
  ('Antoine Paley', '2025-09-29', 'presentiel_exceptionnel', '5033666578', 'SIG _ AUDREY T''explique (capsule 1)', true),
  ('Charlyne Féneant', '2025-09-29', 'presentiel_exceptionnel', '5033666578', 'SIG _ AUDREY T''explique (capsule 1)', true),
  ('Maëlle Das Neves', '2025-09-29', 'presentiel_exceptionnel', '5033666578', 'SIG _ AUDREY T''explique (capsule 1)', true),
  ('Martin Pavloff', '2025-09-29', 'presentiel_exceptionnel', '5033666578', 'SIG _ AUDREY T''explique (capsule 1)', true),
  ('Charlyne Féneant', '2025-10-21', 'presentiel_exceptionnel', '5033666733', 'FJAF CQTONJOB', true),
  ('Antoine Paley', '2026-01-30', 'presentiel_exceptionnel', '5036355347', 'PROMO _ XP VOEUX 1', true),
  ('Antoine Paley', '2026-06-12', 'presentiel_exceptionnel', '2933099348', 'CORRIGE BAC MATHS ANTICIPES hors SPE', true),
  ('Lisa Mazal', '2026-06-12', 'presentiel_exceptionnel', '2933099348', 'CORRIGE BAC MATHS ANTICIPES hors SPE', true),
  ('Maëlle Das Neves', '2026-06-12', 'presentiel_exceptionnel', '2933099348', 'CORRIGE BAC MATHS ANTICIPES hors SPE', true),
  ('Martin Pavloff', '2026-06-12', 'presentiel_exceptionnel', '2933099348', 'CORRIGE BAC MATHS ANTICIPES hors SPE', true),
  ('Antoine Paley', '2026-06-15', 'presentiel_exceptionnel', '2933092127', 'CORRIGE BAC Techno Philo', true),
  ('Lisa Mazal', '2026-06-15', 'presentiel_exceptionnel', '2933092127', 'CORRIGE BAC Techno Philo', true),
  ('Maëlle Das Neves', '2026-06-15', 'presentiel_exceptionnel', '2933092127', 'CORRIGE BAC Techno Philo', true),
  ('Martin Pavloff', '2026-06-15', 'presentiel_exceptionnel', '2933092127', 'CORRIGE BAC Techno Philo', true),
  ('Antoine Paley', '2026-06-16', 'presentiel_exceptionnel', '2984075088', 'CORRIGE BAC SPE J1_SES_4/5', true),
  ('Lisa Mazal', '2026-06-16', 'presentiel_exceptionnel', '2984075088', 'CORRIGE BAC SPE J1_SES_4/5', true),
  ('Maëlle Das Neves', '2026-06-16', 'presentiel_exceptionnel', '2984075088', 'CORRIGE BAC SPE J1_SES_4/5', true),
  ('Martin Pavloff', '2026-06-16', 'presentiel_exceptionnel', '2984075088', 'CORRIGE BAC SPE J1_SES_4/5', true),
  ('Antoine Paley', '2026-06-26', 'presentiel_exceptionnel', '3028293157', 'CORRIGE BREVET FRANCAIS', true),
  ('Lisa Mazal', '2026-06-26', 'presentiel_exceptionnel', '3028293157', 'CORRIGE BREVET FRANCAIS', true),
  ('Maëlle Das Neves', '2026-06-26', 'presentiel_exceptionnel', '3028293157', 'CORRIGE BREVET FRANCAIS', true),
  ('Martin Pavloff', '2026-06-26', 'presentiel_exceptionnel', '3028293157', 'CORRIGE BREVET FRANCAIS', true),
  ('Antoine Paley', '2026-06-29', 'presentiel_exceptionnel', '3050973227', 'CORRIGE BREVET Histoire Géo', true),
  ('Lisa Mazal', '2026-06-29', 'presentiel_exceptionnel', '3050973227', 'CORRIGE BREVET Histoire Géo', true),
  ('Maëlle Das Neves', '2026-06-29', 'presentiel_exceptionnel', '3050973227', 'CORRIGE BREVET Histoire Géo', true),
  ('Martin Pavloff', '2026-06-29', 'presentiel_exceptionnel', '3050973227', 'CORRIGE BREVET Histoire Géo', true),
  ('Antoine Paley', '2026-06-30', 'presentiel_exceptionnel', '3050995730', 'CORRIGE BREVET Maths', true),
  ('Lisa Mazal', '2026-06-30', 'presentiel_exceptionnel', '3050995730', 'CORRIGE BREVET Maths', true),
  ('Maëlle Das Neves', '2026-06-30', 'presentiel_exceptionnel', '3050995730', 'CORRIGE BREVET Maths', true),
  ('Martin Pavloff', '2026-06-30', 'presentiel_exceptionnel', '3050995730', 'CORRIGE BREVET Maths', true),
  ('Thomas Clicteur', '2026-07-03', 'presentiel_exceptionnel', '2979089436', 'CQUOI_FJAF', true);

-- 1 ligne laissée telle quelle (tournage futur, pas encore réalisé)
-- id 1979511f-2922-4cb1-8735-b1960c72d38d (ITR_OPCO_SANTE) : confirme reste à false, à retraiter après le tournage
