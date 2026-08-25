# Session de travail — 25 août 2026 (suite 3, clôture)
## Perimeter — Chantier D33 complet : présentiel exceptionnel, écriture n8n directe, vérification croisée

*Session technique dense — Mac Bureau puis Mac Maison*

---

## Chantiers traités

### Écriture directe de JSON n8n (nouveau mode de collaboration)
Constat en cours de session : configurer un node n8n à la main (clics, menus) est lent et source d'erreurs. Nouvelle méthode adoptée : JARVIS écrit directement le JSON du workflow (nodes + connexions), Martin colle sur le canvas (Cmd+V) au lieu de configurer champ par champ. Gain de temps et de précision confirmé — devient la méthode par défaut pour les prochains chantiers n8n.

### Pipeline "présentiel exceptionnel" (2e volet de D33)
Construit de bout en bout : récupération des items du board Monday, classification, écriture Supabase.

**Piège majeur découvert en cours de route** : le node natif n8n "Monday.com — Get Many Items" plafonne silencieusement à 240 items sur les 814 réels du board, sans message d'erreur. Contournement : appel direct à l'API Monday en GraphQL avec pagination manuelle par curseur (deux requêtes HTTP Request chaînées, 500 items max par page).

**Deux bugs identifiés et corrigés par vérification croisée avec l'export Excel** (méthode : recalcul indépendant en Python, comparé ligne à ligne à la sortie n8n — sur demande explicite de Martin, "vérifie toi-même depuis l'Excel") :
1. La requête GraphQL ne demandait pas la colonne "Responsable Backup" — le filet de secours cherchait dans le vide.
2. Confusion Antoine Paley / Antoine Vassas (rédacteur en chef, hors roster D33) — le token "ANTOINE" seul matchait les deux, 3 événements mal attribués en base ont dû être nettoyés (`DELETE` ciblé).

### Recadrage majeur de la logique métier (à la demande de Martin)
Trois ajustements demandés après relecture des premiers résultats :
1. **Filtre Pôles** : exclusion des tournages où la Cellule Vidéo n'intervient pas (StudyAdvisor, Solo Redac, Pôle ?)
2. **Rythme antérieur au 13/10/2025** : présentiel mardi/mercredi (TT lundi/jeudi/vendredi), en vigueur depuis le 01/09/2024 — le Code node gère maintenant deux périodes de rythme successives
3. **Attribution par défaut** : quand ni Resp. Tournage ni Responsable Backup n'identifient personne, le jour est attribué par défaut à Martin plutôt qu'ignoré

Cette dernière décision a fait bondir le volume de 19 à 115 événements bruts (96 attribués à Martin, dont 81 sans aucune information — juste le défaut appliqué). JARVIS a signalé le risque de mélanger faits confirmés et suppositions dans une donnée à visée d'argumentation RH. Décision de Martin : garder l'attribution par défaut, mais la distinguer clairement via une colonne `confirme` (booléenne) — les cas non confirmés seront affinés plus tard par croisement mail/Teams/calendrier.

### Vérification finale
Total en base validé par calcul indépendant avant exécution : **68 lignes** (12 `tt_exceptionnel` + 56 `presentiel_exceptionnel`, dont 15 confirmés et 41 estimés). Le chiffre obtenu dans Supabase après exécution correspond exactement.

---

## Décisions actées

- **D36** — Rythme antérieur au 13/10/2025 : présentiel mardi/mercredi, TT lundi/jeudi/vendredi, en vigueur depuis le 01/09/2024.
- **D37** — Détection présentiel exceptionnel : filtre Pôles (exclusion StudyAdvisor/Solo Redac/Pôle ?), repli Responsable Backup, attribution par défaut à Martin Pavloff quand personne n'est identifié, distinction confirmé/estimé via colonne `confirme`.
- Nouvelle méthode de travail n8n : JARVIS écrit le JSON des workflows directement, Martin colle sur le canvas plutôt que de configurer chaque champ manuellement.
- Les 41 événements non confirmés seront affinés ultérieurement par croisement avec mail, Teams et calendrier — pas construit cette session, juste acté comme prochaine étape.

---

## Livrables produits

| Fichier / Élément | Nature | État |
|---|---|---|
| `n8n-workflows/PERIMETER_MANAGEMENT_EQUIPE_PRESENTIEL_TT.json` | Workflow n8n complet (TT + présentiel) | ✅ Versionné, commit `b5b7809` |
| `docs/PERIMETER_DOCUMENT_FONDATEUR_V1_6.md` | Document fondateur | ✅ D36, D37, état final D33, commit `c78fd93` |
| Table `presentiel_tt_evenements` | Données Supabase | ✅ 68 lignes, colonne `confirme` ajoutée |
| Colonne `confirme` (ALTER TABLE) | Schéma Supabase | ✅ Appliquée (SQL Editor, non versionnée en migration séparée — à noter) |

---

## Pièges découverts

- **Le node n8n "Monday.com — Get Many Items" plafonne silencieusement à 240 items sur un board de 814, sans erreur.** Contournement : appel GraphQL direct à l'API Monday avec pagination par curseur. À garder en tête pour tout futur chantier n8n + Monday sur un gros board.
- **Confusion possible entre deux personnes de même prénom** ("Antoine" = Paley ou Vassas) dans un champ people en texte libre — une règle de désambiguïsation pensée pour un contexte (nom d'item Monday) ne s'applique pas forcément à un autre (champ "personne" réel). Toujours vérifier le contexte d'usage d'une règle de matching avant de la réutiliser ailleurs.
- **Un changement demandé sur un critère de détection peut faire exploser le volume de données sans que ce soit visible avant de compter précisément.** Le passage de "ignorer les cas ambigus" à "attribuer par défaut" a multiplié le volume par 6 — toujours quantifier avant d'accepter un changement de logique, ne pas se fier à l'intuition sur le volume attendu.
- Un `ALTER TABLE` fait à la main dans le SQL Editor Supabase (comme les précédentes migrations manuelles) n'est pas automatiquement versionné — la colonne `confirme` n'a pas de fichier de migration dédié dans le repo. Dette mineure, à traiter à l'occasion.

---

## Prochaines étapes

1. Créer un fichier de migration pour la colonne `confirme` (dette mineure, cohérence avec les autres migrations versionnées)
2. Affiner les 41 événements non confirmés par croisement avec mail, Teams et calendrier — chantier à cadrer (quelles sources, quel niveau d'automatisation)
3. Gestion de la rotation annuelle du board Monday au 8 octobre (bascule d'une saison à l'autre non construite)
4. Déclenchement automatique du workflow (D5, encore manuel à ce stade pour tous les azimuts Perimeter)
5. Migration n8n vers Oracle Cloud Free Tier (D30/D21) — toujours pertinente pour l'indépendance vis-à-vis du Mac Maison
6. Chantier dédié : interprétation Ollama pour détecter les "points" de l'azimut Calendrier & temps (D31)

---

*Session 25 août 2026 (suite 3, clôture) · Perimeter · Mac Bureau puis Mac Maison*
