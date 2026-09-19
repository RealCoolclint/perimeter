# Session de travail — 19 septembre 2026
## Perimeter — Diagnostic lieu Outlook, tentative de correctif, rate limit Monday

*Session opérationnelle de débogage et de durcissement — protocole de démarrage appliqué (git pull, lecture fondateur V1.14 + récap 18/09), aucune décision de fond nouvelle sur le scope produit, deux décisions techniques actées (D69, D70)*

---

## Contexte de reprise

Session de suite directe de celle du 18/09/2026 (validation du moteur Ollama en conditions réelles, 3 bugs corrigés, premier succès de bout en bout). Trois pistes de reprise traitées dans l'ordre annoncé : identifiants n8n, champ Outlook `location` vide, rate limit Monday GraphQL.

---

## Chantiers traités

### 1. Identifiants n8n — documentés

Retrouvés de mémoire par Martin, puis enregistrés dans le gestionnaire de mots de passe d'Opera (son navigateur). Consigné dans la mémoire de travail (Carnet de Pièges) — ce n'est pas un document du repo Perimeter, donc pas de commit associé.

### 2. Champ Outlook `location?.displayName` vide — diagnostiqué, correctif reporté

**Diagnostic confirmé par Martin** : les lieux concernés ("Studio Canapé", "Studio Pegboard", etc.) sont des configurations de tournage renseignées uniquement dans Monday (colonne `LIEU`, id technique `label__1`, colonne de type Statut), jamais dans le champ Location structuré d'Outlook. Ce n'est pas un bug — c'est la mauvaise source qui était interrogée pour cette information.

**Défaut d'architecture découvert en creusant, antérieur à cette session** : le node "Détection tournage Martin (jour)" est branché en aval de "Get items item by column value (Télétravail)", qui ne récupère que les items Monday `Statut Prod = Absence` — alors que le code de détection exclut explicitement ces mêmes items. Ce node n'a probablement jamais pu détecter un vrai tournage depuis sa création (D46), silencieusement.

**Tentative de correctif, testée puis entièrement annulée** : un node Merge devait faire attendre "Préparer signaux Ollama" jusqu'à ce que la détection Monday soit terminée, pour lui transmettre le lieu trouvé. Testé en conditions réelles (bouton "Execute workflow") : la branche Monday ne s'est jamais déclenchée, et le node Ollama est resté bloqué en attente indéfiniment — confirmant que coupler les deux branches rendrait tout le pipeline calendrier (Google + Outlook) dépendant d'une chaîne Monday qui peut légitimement ne renvoyer aucun item. Risque de régression sur le pipeline validé la veille jugé trop élevé pour un correctif testé sans données réelles (samedi, calendrier vide). Entièrement annulé avant tout push en production — rien de risqué n'est resté dans le fichier local.

**Ce qui reste acquis, sans risque, déjà en production** : id de colonne Monday `label__1` ajouté à la requête GraphQL (page 1 et page 2), correction de casse `'LIEU'` → `'Lieu'` dans le code de détection, et correction du fuseau horaire Outlook (voir ci-dessous).

### 3. Rate limit Monday GraphQL — filet de sécurité posé

Confirmé avec Martin : le rate limit ne s'est produit qu'en session de test (rafales de ré-exécutions rapprochées), jamais en usage courant — Perimeter n'étant pas encore utilisé quotidiennement. Retry avec délai ajouté (4 tentatives, 8 secondes d'attente) sur les trois nodes qui appellent l'API Monday. Filet de sécurité assumé comme non définitif (pas d'exploitation de l'en-tête `Retry-After`), suffisant pour l'usage actuel.

### Correctif additionnel, découvert en cours de route

Le node "Préparer signaux Ollama" affichait l'heure de début des événements Outlook en UTC brut, sans conversion — contrairement au node `poids_journee` qui convertit en Europe/Paris depuis D46. Corrigé dans la même passe que le nettoyage post-tentative-Merge.

---

## Décisions actées

- **D69** — Premier test réel du workflow `xkS15S1PWCDYULRv` validé le 18/09 (3 bugs corrigés). Conversion Europe/Paris ajoutée pour l'heure de début Outlook dans "Préparer signaux Ollama" le 19/09.
- **D70** — Retry avec délai (4 tentatives, 8s) sur les trois nodes appelant l'API Monday, contre le rate limit de test. Non définitif, à revoir seulement si le problème survient en usage réel.

---

## Livrables produits

| Fichier / Élément | Nature | État |
|-------------------|--------|------|
| `n8n-workflows/D69_fuseau_horaire_outlook_et_prep_lieu.json` | Sauvegarde workflow (D69) | ✅ Poussé sur `main` |
| `n8n-workflows/D70_retry_monday_rate_limit.json` | Sauvegarde workflow (D70) | ✅ Poussé sur `main` |
| `docs/PERIMETER_DOCUMENT_FONDATEUR_V1_15.md` | Document fondateur mis à jour | ✅ À pousser (commande ci-dessous) |
| Colonne Monday `LIEU` (`label__1`) ajoutée à la requête GraphQL | Modification workflow | ✅ En production |
| Node "Attendre Monday avant Ollama" (Merge) | Tentative de correctif | ⚫ Créé puis entièrement supprimé, jamais poussé en prod |

---

## Commandes Terminal produites

```bash
# Pousser le document fondateur mis à jour
cd ~/Documents/GitHub/perimeter
git add docs/PERIMETER_DOCUMENT_FONDATEUR_V1_15.md docs/SESSION_TRAVAIL_20260919_PERIMETER_LIEU_OUTLOOK_RATE_LIMIT.md
git commit -m "V1.15 : D69/D70 actées, chantier lieu Outlook scopé et reporté, rate limit Monday durci"
git push
```

---

## Pièges découverts

- **Une double connexion vers un même node ne force pas l'ordre d'exécution en n8n**, même en `executionOrder: v1` — testé en conditions réelles, la branche censée être attendue ne s'est jamais déclenchée. Seul un vrai node **Merge** garantit qu'un node attend que toutes ses entrées soient prêtes avant de s'exécuter.
- **Un node en aval d'une chaîne sans `alwaysOutputData` peut se retrouver structurellement privé de données** si la chaîne amont filtre sur un critère qui exclut justement ce que le node aval cherche — ici, "Détection tournage Martin (jour)" cherchait des tournages sur une branche qui ne remonte que des items `Absence`. À vérifier systématiquement : le filtre en tête de chaîne est-il compatible avec ce que cherche le node en bout de chaîne ?
- **Le testeur d'API Monday (`monday.com/developers/v2/try-it-yourself`) est le moyen le plus rapide de retrouver l'id technique d'une colonne** (`columns { id title }`), sans dépendre du plan Monday pour l'option "Copier l'ID de colonne" dans l'interface (absente sur certains plans).
- **Le rate limit Monday observé en session n'est pas un problème de production** — confirmé par Martin, ça n'arrive qu'en rafale de tests rapprochés. Ne pas sur-corriger un problème qui n'existe qu'en conditions de développement.

---

## Prochaines étapes

1. Pousser le document fondateur mis à jour sur GitHub (commande ci-dessus)
2. Construire le pipeline n8n Boîte mail (D48) — condition pour couvrir les 8 azimuts prévus par le moteur Ollama
3. Chantier dédié : requête Monday indépendante pour le lieu de tournage (voir section 11 du fondateur V1.15) — à mener un jour de semaine, avec de vraies données
4. Seuils (D15) et constantes k (D26) pour les 9 nouveaux azimuts
5. Source fiable pour "Mémoire & connaissance" (D55)

---

*Session 19 septembre 2026 · Perimeter · à distance (Claude)*
