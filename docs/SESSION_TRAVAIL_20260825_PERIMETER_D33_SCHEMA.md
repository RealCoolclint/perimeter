# Session de travail — 25 août 2026 (suite 2)
## Perimeter — Chantier D33 : structure Monday, schéma Supabase, rythme fixe

*Session technique — Mac Bureau*

---

## Chantiers traités

### Rapatriement du récap manquant
Le récap de la session précédente (sauvegarde n8n, veille, D33) était resté uniquement dans les ressources du projet Claude, jamais commité sur GitHub — même famille de risque que la perte passée de `PERIMETER_VEILLE_OPENSOURCE.md`. Rapatrié et poussé (`docs/SESSION_TRAVAIL_20260825_PERIMETER_BACKUP_VEILLE_D33.md`, commit `4be9c34`).

### Analyse de la structure du board Monday `5033664702`
Deux exports Excel analysés. Le premier (26 colonnes) ne contenait pas de colonne Période — insuffisant pour fiabiliser la détection RTT/TT. Un second export plus complet (38 colonnes) a révélé les colonnes `Période - Start` / `Période - End`, remplies pour 109 des 114 lignes au statut `Absence`. Ces colonnes sont la source fiable pour dater les événements RTT/TT/Congé/École.

Piège de classification identifié : le mot "TT" est une sous-chaîne de "RTT" — la détection doit chercher "TT" comme token isolé, jamais précédé de "R". Sur les données actuelles, 5 items TT propres identifiés (`ANTOINE TT`, `LISA TT`, `Antoine TT` ×3), contre une dizaine de RTT distincts.

Anomalie mineure repérée : `TT_MAELLE` n'a pas suivi la convention Période — utilise `Date de tournage` à la place (prévoir un filet de sécurité dans le futur Code node). Certaines lignes taguées `Absence` sont en réalité de vraies productions mal classées (sans Période remplie) — le filtre `Absence` + `Période` non vide les exclut naturellement.

### Rythme fixe (D33/D34)
Rythme confirmé : identique pour toute l'équipe suivie (Thomas Clicteur, Antoine Paley, Charlyne Féneant, Lisa Mazal, Maëlle Das Neves) — TT lundi/mardi/vendredi, présentiel mercredi/jeudi, en vigueur depuis le 13/10/2025. Périodes "école" des alternantes traitées comme hors-jeu, sans détection TT/présentiel ce jour-là — choix de simplicité assumé pour ce cas rare.

Règle de désambiguïsation actée : "Antoine" seul dans un item = Antoine Paley (jamais Antoine Vassas, hors équipe directe).

### Schéma Supabase D33
Deux tables créées et versionnées : `rythme_config` (config datée du rythme) et `presentiel_tt_evenements` (événements détectés, contrainte unique personne+date+type, RLS service_role). Exécuté via le SQL Editor du dashboard Supabase (pas de CLI configuré sur le Mac Bureau). Migration versionnée dans le repo.

Angle mort découvert au passage : le premier schéma Supabase (`points`, `tours`, `contexte_journee`, 24 août) n'avait jamais été commité sur GitHub, seulement appliqué via CLI en local. Non corrigé cette session — pas bloquant, à traiter plus tard.

### Blocage n8n / Mac Bureau
Le node n8n Monday.com nécessaire pour lire le JSON réel du board ne peut pas être configuré depuis le Mac Bureau — n8n Docker local n'existe que sur le Mac Maison, migration Oracle Cloud (D21/D30) pas encore faite. Proposition de basculer sur la migration Oracle Cloud pendant cette session Bureau déclinée par Martin — reportée à une prochaine session.

---

## Décisions actées

- **D34** — Colonnes `Période - Start` / `Période - End` = source de vérité pour dater RTT/TT/Congé/École sur `5033664702`. Rythme fixe D33 : TT lundi/mardi/vendredi, présentiel mercredi/jeudi, identique pour toute l'équipe, depuis le 13/10/2025. "Antoine" seul = toujours Antoine Paley. Périodes école = exclues de toute détection.
- **D35** — Détection TT = token "TT" isolé, jamais précédé de "R" (exclusion stricte de RTT).
- Angle mort noté : le schéma Supabase initial (24 août) reste non versionné sur GitHub — dette non prioritaire.

---

## Livrables produits

| Fichier / Élément | Nature | État |
|---|---|---|
| `docs/SESSION_TRAVAIL_20260825_PERIMETER_BACKUP_VEILLE_D33.md` | Récap rapatrié | ✅ Poussé, commit `4be9c34` |
| `supabase/migrations/20260825000001_presentiel_tt_schema.sql` | Migration SQL versionnée | ✅ Poussé, commit `2f993c6` |
| Tables `rythme_config` + `presentiel_tt_evenements` | Infrastructure Supabase | ✅ Créées et vérifiées |
| `docs/PERIMETER_DOCUMENT_FONDATEUR_V1_5.md` | Document fondateur | ✅ Mis à jour (D34, D35, état D33), à pousser |

---

## Commandes Terminal produites

```bash
# Rapatrier un récap resté uniquement dans les ressources projet vers le repo GitHub
cd ~/Documents/GitHub/perimeter
git add docs/SESSION_TRAVAIL_20260825_PERIMETER_BACKUP_VEILLE_D33.md
git commit -m "Rapatrie récap 25/08 (sauvegarde n8n, veille, D33) — était resté uniquement dans les ressources projet"
git push
```

```bash
# Versionner le schéma Présentiel/TT après exécution manuelle dans le SQL Editor Supabase
cd ~/Documents/GitHub/perimeter
mkdir -p supabase/migrations
git add supabase/migrations/20260825000001_presentiel_tt_schema.sql
git commit -m "Versionne le schéma Présentiel/TT (D33) — rythme_config + presentiel_tt_evenements"
git push
```

---

## Pièges découverts

- Un récap produit dans l'environnement JARVIS peut finir uniquement dans les ressources du projet Claude si on ne le pousse pas explicitement sur GitHub → toujours vérifier `ls docs/SESSION_TRAVAIL_*.md | sort | tail` en fin de session.
- "RTT" contient "TT" comme sous-chaîne → toute détection par mot-clé doit chercher un token isolé, jamais un simple `includes()`.
- Un item Monday peut utiliser `Date de tournage` par erreur à la place de `Période` (`TT_MAELLE`) → prévoir un filet de secours plutôt que de rejeter la ligne.
- Le SQL Editor Supabase n'accepte que du SQL — un bloc Terminal collé dedans casse immédiatement (`syntax error at or near "cd"`) → toujours bien séparer les blocs SQL et Terminal dans la réponse.
- Un schéma Supabase peut être appliqué via CLI sans jamais être commité sur GitHub → vérifier systématiquement qu'un dossier `supabase/migrations/` existe et est à jour avant de considérer un chantier Supabase "propre".

---

## Prochaines étapes

1. Prochaine session sur Mac Maison : ouvrir n8n, ajouter le node Monday.com sur le board `5033664702`, exécuter en test et partager le JSON brut retourné (1-2 items suffisent) — nécessaire pour écrire le Code node de classification
2. Écrire le Code node n8n : classification TT (token isolé, exclusion RTT), calcul présentiel exceptionnel (croisement Date de tournage / Resp. Tournage avec le rythme fixe), écriture dans `presentiel_tt_evenements`
3. Migration n8n vers Oracle Cloud Free Tier (D30/D21) — chantier compatible Mac Bureau, lèverait le blocage actuel définitivement
4. Dette technique à traiter à l'occasion : versionner le schéma Supabase initial du 24 août sur GitHub
5. Chantier dédié : interprétation Ollama pour détecter les "points" de l'azimut Calendrier & temps (D31)

---

*Session 25 août 2026 (suite 2) · Perimeter · Mac Bureau (mpavloff)*
