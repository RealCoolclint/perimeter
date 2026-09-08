# Session de travail — Perimeter — 07/09/2026 (soir)

*Construction du pipeline n8n Outlook + Monday pour le poids journée (D16, D45→D46)*

---

## Chantiers traités

### Fusion Google Calendar + Outlook, sans dédup
Décision actée en début de session : les deux calendriers (perso Google, pro Outlook L'Étudiant) ne contiennent jamais les mêmes événements — pas besoin de logique de déduplication. Les heures de réunion des deux sources se cumulent simplement pour le calcul de la majoration "journée dense" (D16).

### Détection terrain : abandon du champ Lieu, croisement Monday
Les événements Outlook remontés par l'automatisation Monday→Outlook n'ont pas de champ `location` renseigné — l'info de tournage est produite côté Monday, pas dans le calendrier. Décision actée : le signal terrain de D16 passe désormais **uniquement** par un cross-check du board Monday `5033664702` (même board et même logique que D33/D37 : filtre Pôles, Statut Prod ≠ Absence, Resp. Tournage ou Responsable Backup = Martin, date du jour). La détection par champ Lieu (Google) est abandonnée pour ce signal, sur choix explicite de Martin.

### Nouvelle méthode de travail : Cursor + API REST n8n
Bascule actée en cours de session : Cursor devient l'unique éditeur des workflows n8n de Perimeter, via leur export JSON — plus de collage manuel de code JS dans l'interface n8n. La synchronisation entre le fichier local et l'instance n8n en direct passe par l'API REST n8n (`PUT /api/v1/workflows/{id}`, clé API dans les Settings n8n), pas par Import/Export manuel. Script créé : `n8n-workflows/sync_workflow.sh {id} pull|push`, clé stockée dans `~/.config/perimeter/n8n_api_key` (jamais versionnée, jamais dans le repo).

### Construction du pipeline complet
Nouveau Code node "Détection tournage Martin (jour)" créé (réutilise la logique de classification D37, filtrée sur Martin et la date du jour). Chaîne d'exécution réordonnée pour que le calcul du `poids_journee` (node "Code in JavaScript") s'exécute après que Google, Outlook et Monday aient tous produit leurs données — nécessite un réordonnancement des connexions fait en plusieurs prompts Cursor successifs. Code du node "Code in JavaScript" réécrit pour fusionner les trois sources. `alwaysOutputData: true` ajouté sur les nodes Google et Outlook pour éviter qu'une journée sans événement n'interrompe toute la chaîne (y compris la branche Présentiel/TT, sans lien avec le calendrier perso).

### Bug détecté et corrigé : sous-comptage Outlook
Premier test complet réussi visuellement, mais Martin a comparé le résultat à ses vrais agendas (captures Google + Outlook) et repéré un écart flagrant sur le nombre d'événements comptés. Cause : le node Outlook était resté configuré avec `limit: 5` (réglage de test du tout début de session), jamais mis à `returnAll: true` malgré plusieurs allers-retours. Corrigé. Le re-test après correction n'a pas pu être rejoué avant la fin de session — bloqué par un rate-limit temporaire de l'API Monday.com, provoqué par le nombre d'exécutions successives du workflow pendant la session.

---

## Décisions actées

- Pas de déduplication Google/Outlook — calendriers disjoints (perso/pro), cumul simple des heures
- Signal terrain de D16 : Monday (board `5033664702`) seul fait foi, abandon du champ Lieu
- Workflows n8n de Perimeter : édition via Cursor sur le JSON exporté, synchronisation via l'API REST n8n plutôt que l'UI Import/Export
- `n8n-workflows/sync_workflow.sh {id} pull|push` devient l'outil systématique pour tout travail futur sur un workflow n8n de Perimeter

---

## Livrables produits

| Fichier / Élément | Nature | État |
|-------------------|--------|------|
| `n8n-workflows/sync_workflow.sh` | Script bash (pull/push API n8n) | ✅ |
| Workflow `xkS15S1PWCDYULRv` (nodes Outlook + Monday + calcul poids_journee) | Config n8n live | 🟡 corrigé, re-test à confirmer |
| `n8n-workflows/xkS15S1PWCDYULRv.json` | Snapshot du workflow | ✅ à jour au moment de la clôture |
| `PERIMETER_DOCUMENT_FONDATEUR_V1_12.md` | Doc fondateur | ✅ |
| `n8n-workflows/Test_Connexion_Outlook.json` | Ancien fichier de test | ⚫ obsolète, à supprimer |

---

## Pièges découverts

- n8n : `$now` et `DateTime` sont natifs et globaux dans un Code node (confirmé via le code source de `n8n-workflow` sur npm/socket.dev) — pas besoin de `require('luxon')`, malgré une affirmation répétée à deux reprises par Cursor en ce sens
- n8n : le node Microsoft Outlook (typeVersion 2) n'a pas de champs "Depuis/Jusqu'à" séparés visibles par défaut — il faut activer "Include Recurring Event Instances" pour faire apparaître `startDateTime`/`endDateTime` en top-level ; sinon seul un champ `filters.custom` (OData libre) est proposé
- n8n API REST : `PUT /api/v1/workflows/{id}` rejette toute clé hors de `name`, `nodes`, `connections`, `settings` — un export brut (avec `id`, `active`, `createdAt`...) doit être nettoyé avant renvoi
- n8n API REST : toujours `pull` juste avant d'écrire un prompt Cursor qui référence des noms de nodes — un renommage fait ailleurs (UI, autre fichier) ne se propage jamais tout seul
- n8n API REST : ne jamais enchaîner deux éditions Cursor sans `push` entre les deux — un `pull` avant la seconde écraserait silencieusement la première si elle n'a pas été renvoyée à n8n (perdu une connexion de cette façon pendant la session)
- n8n : sans `alwaysOutputData: true`, un node source qui retourne zéro résultat (ex : jour sans événement calendrier) interrompt toute la suite de la chaîne, y compris des branches sans rapport
- Outlook (Microsoft Graph via Monday→Outlook) : les événements n'ont pas de champ `location` renseigné — ne pas s'y fier pour la détection terrain sur ce compte
- macOS Terminal (zsh) : `read -s -p "message"` échoue silencieusement ("no coprocess") — utiliser `printf` séparé puis `read -s` sans `-p`
- Une variable `export` ne survit pas à un changement d'onglet/fenêtre Terminal — vérifier `tty` en cas de comportement "clé soudainement vide"

---

## Prochaines étapes

1. Rejouer le test complet du workflow `xkS15S1PWCDYULRv` une fois le rate-limit Monday.com passé, et confirmer que `nb_evenements_outlook` correspond bien au calendrier réel
2. Révoquer l'ancienne clé API n8n exposée en clair dans le chat à deux reprises pendant la session, en générer une nouvelle si besoin de continuer à s'en servir
3. Supprimer `n8n-workflows/Test_Connexion_Outlook.json` (obsolète, remplacé par `xkS15S1PWCDYULRv.json`)
4. Retraiter le jour du 22/09/2026 une fois le tournage réalisé (reporté depuis plusieurs sessions, toujours bloqué par le calendrier réel)

---

*Session 07/09/2026 (soir) · Perimeter · Mac Bureau*
