# Session de travail — 25 août 2026
## Perimeter — accès direct JARVIS, premier azimut Calendrier & temps de bout en bout

*Session longue — infrastructure + premier azimut fonctionnel*

---

## Chantiers traités

### Accès direct JARVIS au repo
Le relais manuel terminal (copier-coller de commandes) remplacé par un accès direct : le repo `perimeter` est passé en **public**, ce qui permet à JARVIS de cloner/lire directement via son environnement bash, sans authentification ni token. Protocole de démarrage mis à jour en conséquence. Condition de réversibilité actée : dès que Perimeter contient de la donnée réelle sensible (tensions d'équipe nominatives, candidatures en cours), la question du retour en privé doit être reposée.

### Schéma Supabase initial
Création du projet Supabase (`perimeter`, région Europe). Premier commit de migration (`20260824000001_init_schema.sql`) : tables `points`, `tours`, `contexte_journee`, RLS activé (service_role uniquement), indexes sur `points(azimut)` et `points(resolu_le)`. Migration poussée avec succès via Supabase CLI.

### Environnement n8n
Docker Desktop installé. n8n lancé en local via conteneur Docker (volume persistant `~/.n8n-perimeter`), décision actée de valider la logique en local avant migration vers Oracle Cloud Free Tier (évite de mélanger debug infra et debug logique).

### Premier workflow n8n — poids journée (D16)
Connexion Google Calendar OAuth2 configurée (Google Cloud Console : projet, API activée, écran de consentement, client OAuth, utilisateur test ajouté). Workflow construit et testé de bout en bout :
`Manual Trigger → Get many events (Google Calendar, plage "aujourd'hui") → Code (calcul poids_journee) → HTTP Request (écriture Supabase contexte_journee)`.
Premier enregistrement réel confirmé dans la table `contexte_journee`.

### Clarification du concept de "point" pour Calendrier & temps
Le doc fondateur ne précisait pas ce qu'est un "point" pour cet azimut (contrairement à Management d'équipe). Plusieurs méthodes de détection automatique proposées (préfixe de titre, Google Tasks, calendrier dédié) — toutes écartées par Martin au profit d'une **couche d'interprétation intelligente (Ollama)**, jugée nécessaire pour lire correctement le calendrier plutôt qu'une convention rigide. Décision de **dissocier ce chantier** du calcul du poids journée (déjà livré) pour ne pas mélanger deux niveaux de complexité.

### Sources de calendrier multiples identifiées
Martin a signalé la nécessité de scruter plusieurs calendriers (Google perso/semi-pro + Outlook pro), pas uniquement Google. Décision d'ordre : Google Calendar d'abord (fait), Outlook ensuite (Microsoft Graph, nécessite une app registration Azure — plus lourd, à traiter comme chantier séparé).

---

## Décisions actées

- **D29** — Repo `perimeter` passé en public pour garantir l'accès direct et fiable de JARVIS (lecture seule via clone Git standard). Condition de réversibilité : dès que la donnée réelle devient sensible, réexaminer.
- **D30** — n8n : développement et validation en local (Docker) d'abord ; migration vers Oracle Cloud Free Tier (D21) une fois la logique métier stable.
- **D31** — Azimut Calendrier & temps : la notion de "point" nécessite une interprétation intelligente du calendrier (Ollama), pas une convention manuelle (préfixe, Google Tasks, calendrier dédié) — chantier dédié à part, dissocié du calcul du poids journée (D16), déjà implémenté et fonctionnel.
- **D32** — Détection "journée de tournage/terrain" (D16) : basée sur le champ Lieu des événements calendrier, comparé à une liste de lieux "bureau" connus (liste à affiner avec l'usage réel).
- Ordre de branchement des sources calendrier acté : Google Calendar d'abord (fait), Outlook (Microsoft Graph) ensuite.

---

## Livrables produits

| Fichier / Élément | Nature | État |
|---|---|---|
| `supabase/migrations/20260824000001_init_schema.sql` | Schéma initial (3 tables) | ✅ poussé et appliqué sur Supabase |
| Projet Supabase `perimeter` | Infrastructure cloud | ✅ créé, migration appliquée |
| Instance n8n locale (Docker) | Infrastructure | ✅ opérationnelle |
| Credential Google Calendar OAuth2 (n8n) | Connexion | ✅ connectée et testée |
| Credential Supabase `service_role` (n8n, Custom Auth) | Connexion sécurisée | ✅ créée |
| Workflow n8n "Calendrier & temps — poids journée" | Premier azimut fonctionnel | ✅ testé de bout en bout, **non versionné** (voir pièges) |
| `docs/PERIMETER_PROTOCOLE_DEMARRAGE_SESSION.md` | Mise à jour (repo public) | ✅ pushé |

---

## Pièges découverts

- **Le workflow n8n n'est sauvegardé nulle part hors du volume Docker local** (`~/.n8n-perimeter`) — pas de version control, pas de backup. Si le conteneur ou le volume est perdu, le travail de cette session sur le workflow est perdu. À corriger : exporter le workflow en JSON et le committer dans `perimeter/n8n-workflows/` à chaque étape significative.
- Un token CLI (Supabase login) est apparu en clair dans un copier-coller de terminal collé dans la conversation — sans risque ici (token à usage unique déjà consommé), mais réflexe à prendre : vérifier avant de coller un historique de terminal.
- Un azimut qui semble "simple et automatique" peut receler une ambiguïté de fond non résolue dans le doc fondateur (ici : la définition même de "point" pour Calendrier & temps) — à vérifier systématiquement avant de coder, pas seulement les sources de données disponibles.
- `supabase db diff` nécessite Docker/une shadow database — pas indispensable pour une vérification simple, le Table Editor suffit dans la majorité des cas.

---

## Prochaines étapes

1. **Exporter et versionner le workflow n8n** (JSON dans le repo) — priorité, pour ne pas perdre le travail
2. Ajouter un vrai déclencheur (Schedule Trigger quotidien, en attendant le déclenchement "à l'ouverture de session" prévu par D5)
3. Affiner la liste `officeLocations` avec les vrais lieux de Martin
4. Chantier dédié : couche d'interprétation Ollama pour détecter les "points" de l'azimut Calendrier & temps
5. Brancher Outlook comme deuxième source calendrier (nécessite app registration Azure)
6. Migration n8n vers Oracle Cloud Free Tier une fois la logique validée plus largement
7. Reconstituer `PERIMETER_VEILLE_OPENSOURCE.md`
8. Workflow n8n annuel Parcoursup

---

*Session 25 août 2026 · Perimeter · Mac Maison (martinpavloff)*
