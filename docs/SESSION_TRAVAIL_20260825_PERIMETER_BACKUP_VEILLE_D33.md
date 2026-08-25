# Session de travail — 25 août 2026 (suite)
## Perimeter — Sauvegarde n8n · Veille open source · Nouvel azimut D33

*Session hybride — Mac Maison puis Mac Bureau*

---

## Chantiers traités

### Sauvegarde du workflow n8n "Calendrier & temps — poids journée"
Le workflow, jusque-là uniquement présent dans le volume Docker local, a été exporté depuis l'interface n8n et versionné dans le repo `perimeter`. Vérifié avant commit : aucun secret exposé, seulement des références de credentials (`id` + `name`).

### Reconstitution de PERIMETER_VEILLE_OPENSOURCE.md
Le fichier original (perdu lors du passage en ressources projet) a été retrouvé par Martin et fourni intégralement. Mis à jour avec les décisions actées depuis le 22 août : Mistral 7B et Oracle Cloud Free Tier passent de 🟡 À évaluer à 🟢 Retenu (D22, D21). Une section "Process de veille" a été ajoutée — deux niveaux (ajout à la volée / revue à la demande), plus léger que le modèle Tranquility Suite à quatre niveaux, adapté à l'échelle d'un projet solo.

### Changement de Mac (Maison → Bureau)
Constat posé : le n8n Docker local n'existe que sur le Mac Maison — rien n'est accessible depuis le Bureau tant que la migration Oracle Cloud (D21) n'est pas faite. Chantiers compatibles avec le Bureau identifiés (migration Oracle, docs, conception). Le repo `perimeter` a été cloné pour la première fois sur le Mac Bureau (`mpavloff`) au passage.

### Conception du nouvel azimut — Suivi Présentiel/TT
Point de départ : besoin de compiler l'information présentiel/TT exceptionnel pour la Cellule Vidéo, dans un contexte de négociation RH réelle (note de service du 24/07/2026 sur l'accord télétravail, fournie par Martin en cours de session).

Décisions de cadrage prises une à une :
- Comptage **par personne**, pas seulement au niveau du pôle
- Source unique : **Monday.com**, board `5033664702` — déjà utilisé pour chiffrer la note de service (37 jours de tournages hors jours fixes sur 9 mois)
- Deux types d'événements suivis : présentiel exceptionnel (tournage un jour TT théorique) et TT exceptionnel (item `TT [Prénom]` sur une période présentielle)
- **Aucune logique de compensation** — Perimeter compile les faits, ne calcule pas de solde correctif
- Contrainte identifiée : le board Monday tourne chaque année au 8 octobre (archives conservées) — à gérer dans la config du futur workflow n8n
- Contrainte identifiée : le rythme fixe présentiel/TT par personne a déjà changé une fois en cours d'année (13/10/2025) — nécessite une config datée, pas une valeur statique

Décision **D33** actée et intégrée au doc fondateur (azimut Management d'équipe + historique des décisions + liste "ce qui reste à trancher").

---

## Décisions actées

- Le fichier de veille open source Perimeter suit un process à deux niveaux (ajout à la volée + revue à la demande), pas le modèle à quatre niveaux de la Tranquility Suite.
- **D33** — Suivi Présentiel/TT : tableau vivant par personne, source Monday.com unique, sans calcul de compensation, à visée d'argumentation factuelle.
- Le n8n Docker local est propre au Mac Maison — aucun chantier touchant directement au workflow "poids journée" n'est possible depuis le Mac Bureau tant que la migration Oracle Cloud n'est pas faite.

---

## Livrables produits

| Fichier / Élément | Nature | État |
|-------------------|--------|------|
| `n8n-workflows/calendrier-temps-poids-journee.json` | Export workflow n8n | ✅ Poussé sur `perimeter` |
| `docs/PERIMETER_VEILLE_OPENSOURCE.md` | Document fondateur | ✅ Reconstitué et poussé, V1.1 |
| `docs/PERIMETER_DOCUMENT_FONDATEUR_V1_4.md` | Document fondateur | ✅ Mis à jour (2 checks + D33), poussé |
| Repo `perimeter` sur Mac Bureau | Clone local | ✅ Premier clone effectué |

---

## Pièges découverts

- Un `mv` vers un repo qui n'a jamais été cloné sur la machine échoue silencieusement en cascade (mv, cd, git add/commit/push tous en erreur) → toujours vérifier qu'un repo est cloné sur une machine avant d'y référencer un chemin, surtout au premier passage sur un nouveau Mac.
- Le n8n Docker (D30) est un environnement local non répliqué — contrairement à Ollama qui tourne "sur le Mac utilisé au moment du tour", n8n n'est disponible que sur la machine où il a été installé, tant que la migration Oracle Cloud (D21) n'est pas faite.

---

## Prochaines étapes

1. Construire le chantier Suivi Présentiel/TT (D33) : workflow n8n Monday.com → Supabase, config datée des rythmes fixes par personne, gestion de la rotation annuelle du board
2. Migration n8n vers Oracle Cloud Free Tier (D30/D21) — chantier compatible Mac Bureau, à prioriser si Martin continue à alterner entre les deux machines
3. Chantier dédié : interprétation Ollama pour détecter les "points" de l'azimut Calendrier & temps (D31)
4. Brancher Outlook comme deuxième source calendrier (nécessite app registration Azure)
5. Workflow n8n annuel Parcoursup
6. Déclencheur automatique du workflow "poids journée" (encore manuel à ce stade)

---

*Session 25 août 2026 · Perimeter · Mac Maison puis Mac Bureau (mpavloff)*
