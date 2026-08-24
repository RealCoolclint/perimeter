# Session de travail — 22 août 2026
## Perimeter — Fondation du projet

*Session stratégique / conception — projet personnel hors Tranquility Suite*

---

## Chantiers traités

### Cadrage de la vision et des contraintes techniques
Exploration en deux temps : d'abord les contraintes techniques réelles source par source (mail, calendrier, Monday, presse, LinkedIn, audience, emploi), puis exploration large de l'écosystème open source disponible pour construire l'app à coût quasi nul.

### Architecture technique
Définition de l'architecture hybride cloud/local : collecte et mémoire dans le cloud (à la demande), intelligence artificielle en local sur la machine utilisée. Choix des briques : n8n (orchestration), Ollama (IA locale), Supabase avec pgvector (mémoire d'état + mémoire sémantique).

### Modèle de déclenchement
Passage d'un modèle "surveillance continue" à un modèle "tour à la demande, déclenché à chaque ouverture de session" — avec mémoire du tour précédent et profondeur adaptative selon le moment de la journée.

### Concept fondateur
Formulation du principe organisateur de tout le projet : le cercle, Martin au centre, les azimuts de préoccupation, l'épaisseur du trait comme représentation de la charge mentale. Décision que ce cercle soit littéralement l'écran d'accueil de l'app, pas un dashboard classique.

### Production des documents
Rédaction du document fondateur et du document de veille open source.

---

## Décisions actées

- Perimeter est un projet personnel, distinct de la Tranquility Suite, hors du Workflow Captif et de l'Agence
- L'architecture est hybride : collecte + mémoire en cloud gratuit à la demande, intelligence IA toujours en local sur la machine active
- Supabase (Postgres + pgvector) est la base de données unique, servant à la fois d'état et de mémoire sémantique
- n8n est le moteur d'orchestration central, sans code custom pour chaque connecteur
- Perimeter se déclenche à chaque ouverture de session Mac, jamais en tâche de fond permanente — aucun Mac à laisser allumé
- Chaque tour est adaptatif : il se souvient du tour précédent et ajuste sa profondeur (1er tour du jour ≠ tours suivants)
- Le concept fondateur du cercle (charge = épaisseur du trait, azimuts = catégories de préoccupation) organise toutes les fonctionnalités
- Le cercle est l'écran d'accueil visuel et central de l'app — pas un dashboard classique en texte

---

## Livrables produits

| Fichier / Élément | Nature | État |
|-------------------|--------|------|
| PERIMETER_DOCUMENT_FONDATEUR.md | Document fondateur | ✅ |
| PERIMETER_VEILLE_OPENSOURCE.md | Veille outils | ✅ |
| SESSION_TRAVAIL_20260822_PERIMETER_FONDATION.md | Récap de session | ✅ |

---

## Pièges découverts

- Un rituel déclenché à chaque ouverture de session risque de reproposer les mêmes éléments plusieurs fois par jour → résolu par une mémoire du dernier tour (Supabase) et une profondeur adaptative selon le nombre d'ouvertures déjà effectuées ce jour-là
- LinkedIn n'offre aucune API officielle viable pour lire le fil d'actualité (posts d'autrui) → la lecture reste manuelle ou semi-assistée ; en revanche, publier en son propre nom est gratuit et sans validation partenaire (`w_member_social`)

---

## Prochaines étapes

1. Trancher la formule de calcul de la charge par azimut (volume × ancienneté × urgence)
2. Confirmer le choix d'hébergement (Oracle Cloud Free Tier ou alternative)
3. Définir les azimuts couverts en V1 vs reportés
4. Session de design dédiée au cercle (skill frontend-design) une fois le contenu stabilisé
5. Trancher la solution pour le blocage LinkedIn en lecture

---

*Session 22 août 2026 · Perimeter (projet personnel) · Machine non précisée*
