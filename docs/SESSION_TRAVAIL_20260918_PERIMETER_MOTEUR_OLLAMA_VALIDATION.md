# Session de travail — 18 septembre 2026
## Perimeter — Validation du moteur Ollama en conditions réelles

*Session opérationnelle de débogage — aucun code d'application touché, uniquement le workflow n8n `xkS15S1PWCDYULRv`*

---

## Contexte de reprise

Session de suite directe de celle du 09/09/2026 (D57-D68 : moteur d'interprétation Ollama entièrement cadré et câblé, jamais exécuté en conditions réelles). `git pull` effectué en ouverture de session — repo déjà à jour, aucune dérive détectée pendant la pause.

---

## Chantiers traités

### Exécution réelle du workflow xkS15S1PWCDYULRv — 3 bugs corrigés

Première exécution réelle du workflow complet. Trois bugs bloquants identifiés et corrigés successivement, chacun validé par ré-exécution avant de passer au suivant :

**Bug 1 — Node "Parser réponse Ollama" en mauvais mode d'exécution**
Le node était configuré en *"Run Once for All Items"* alors que son code (syntaxe `$json`, `$('...').item`) est écrit pour du *"Run Once for Each Item"*. Résultat : sur 11 signaux envoyés à Ollama, un seul était traité (le premier de la liste), les 10 autres silencieusement ignorés. Correction : bascule du mode d'exécution du node.

**Bug 2 — Format de retour incompatible avec le nouveau mode**
Une fois le mode corrigé, le node cassait avec `A 'json' property isn't an object`. Le code retournait `[{ json: {...} }]` (format attendu en mode "All Items") au lieu de `{ json: {...} }` (format attendu en mode "Each Item"). Correction : ajustement du `return`.

**Bug 3 — Doublons dans la réponse brute de l'API Outlook**
Le node "Get many events Outlook" (en `Return All`, pagination automatique) renvoyait certains événements deux fois avec le même `id` — comportement connu de l'API Microsoft Graph sur pagination. Conséquence : deux appels Ollama payés pour le même événement (30 à 80 secondes de calcul gaspillés par doublon). La contrainte d'unicité `event_id` côté Supabase (D68) bloquait bien l'insertion en double, mais en aval seulement — pas de protection contre le gaspillage de calcul. Correction : ajout d'un node de dédoublonnage par `id` juste après "Get many events Outlook", en amont de la séparation vers les deux branches (Ollama + Monday), pour ne dédoublonner qu'une fois.

### Résultat final validé

Exécution complète du workflow avec les 3 corrections en place. Vérification dans Supabase (table `points`) : **3 lignes insérées, une par événement réel du jour, zéro doublon** — pipeline Google/Outlook → dédoublonnage → Ollama → parsing → filtrage → insertion Supabase validé de bout en bout pour la première fois.

### Problème identifié, non traité — Monday GraphQL rate limit

Le node "Monday GraphQL page 1" (branche `poids_journée`, indépendante de la branche Ollama) échoue avec "The service is receiving too many requests from you". Diagnostic posé, pas de correction appliquée cette session — hors périmètre du jour, branche indépendante de l'objectif principal.

### Problème identifié, non traité — champ `location` Outlook toujours vide

Sur les signaux préparés pour Ollama, le champ `Lieu :` ressort systématiquement vide, y compris sur des événements avec un lieu visible dans le titre (ex. "Studio Canapé", "Studio Pegboard") mais pas dans le champ structuré `location` de l'API. Confirme le doute déjà noté en fin de session précédente (point 2 de la liste de reprise) — reste à investiguer.

---

## Décisions actées

Aucune décision de fond (aucun nouveau D-numéro) — session strictement opérationnelle. Le fondateur reste en V1_14, D68 dernière décision actée.

---

## Livrables produits

| Fichier / Élément | Nature | État |
|-------------------|--------|------|
| Node "Parser réponse Ollama" (workflow `xkS15S1PWCDYULRv`) | Correction n8n | ✅ Mode + format de retour corrigés, testé en production |
| Node "Dédoublonner events Outlook" (nouveau, workflow `xkS15S1PWCDYULRv`) | Nouveau node n8n | ✅ Créé, câblé, testé en production |
| `n8n-workflows/xkS15S1PWCDYULRv.json` | Sauvegarde workflow | ⏳ À pousser sur `main` en clôture de session |

---

## Commandes Terminal produites

```bash
# Vérification de synchronisation avant travail (repo déjà à jour)
cd ~/Documents/GitHub/perimeter
git pull
```

```bash
# Sauvegarde du workflow corrigé sur GitHub (à exécuter en clôture)
cd ~/Documents/GitHub/perimeter
./n8n-workflows/sync_workflow.sh xkS15S1PWCDYULRv push
git add n8n-workflows/xkS15S1PWCDYULRv.json
git commit -m "Fix moteur Ollama : mode item-par-item, format retour, dedup events Outlook"
git push
```

---

## Pièges découverts

- **Node de code n8n et mode d'exécution** : un code écrit pour `$json` / `$('Node').item` (singulier) ne fonctionne qu'en mode *"Run Once for Each Item"*. En mode *"Run Once for All Items"*, ces mêmes expressions ne pointent que sur le premier item du lot — aucune erreur explicite, juste un résultat tronqué silencieusement. Toujours vérifier le mode ET le format de `return` ensemble, jamais l'un sans l'autre.
- **API Microsoft Graph (Outlook Calendar) et pagination `Return All`** : peut renvoyer un même événement (même `id`) sur deux pages différentes. Une contrainte d'unicité en base protège contre la corruption de données mais pas contre le gaspillage de calcul en amont — dédoublonner à la source, pas seulement à l'insertion.
- **Identifiants n8n perdus après relance de l'instance locale** : pas stockés dans Bitwarden ni dans un `.env`/`docker-compose` local détectable — à documenter précisément une fois la source réelle confirmée, pour éviter de perdre du temps la prochaine fois.
- **Consigne de méthode actée cette session** : ne plus jamais donner un extrait de code à modifier — toujours le bloc de code complet et propre, même pour un changement d'une ligne. Déjà appliqué dans `ways-of-working.md`.

---

## Prochaines étapes

1. Pousser le workflow corrigé sur GitHub (commande ci-dessus)
2. Investiguer le champ `location?.displayName` toujours vide sur les événements Outlook — point 2 de la reprise, toujours ouvert
3. Résoudre le rate limit "Monday GraphQL page 1" (throttle ou vérification du plan du compte)
4. Construire le pipeline n8n Boîte mail (D48) — condition pour couvrir les 8 azimuts prévus
5. Seuils (D15) et constantes k (D26) pour les 9 nouveaux azimuts
6. Source fiable pour "Mémoire & connaissance" (D55)
7. Documenter précisément l'emplacement des identifiants n8n (piège découvert cette session) une fois la source confirmée

---

*Session 18 septembre 2026 · Perimeter · Mac Maison*
