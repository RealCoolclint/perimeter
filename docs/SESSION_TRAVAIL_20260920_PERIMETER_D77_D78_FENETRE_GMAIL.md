# Session de travail — 20 septembre 2026
## Perimeter — Fenêtre Gmail durcie (D77), piège n8n des expressions multiples (D78)

*Session de suite directe de celle du 20/09 (pipeline Gmail construit et validé, D75-D76 actés, D72 laissé en suspens). Protocole de démarrage appliqué (git pull, lecture fondateur V1.17 + récap du 20/09), aucune dérive détectée. Mac utilisé : Maison.*

---

## Chantiers traités

### 1. Décision D72 tranchée
Trois options posées en fin de session précédente (fenêtre glissante / champ d'ancienneté / cap strict). Option A retenue par Martin : fenêtre glissante de 48h sur le critère "non lu", en plus du critère "reçu aujourd'hui" (D72, inchangé).

### 2. Mise en œuvre et débogage
Premier essai avec deux blocs d'expression `{{ }}` distincts dans le champ de recherche Gmail (`Get many messages Gmail`) : échec silencieux, item fantôme (`alwaysOutputData`) au lieu des vrais résultats. Diagnostic mené par tests empiriques successifs plutôt que par hypothèse :
- Requête testée en clair directement dans Gmail → fonctionne (18 résultats)
- Requête testée avec un seul bloc `{{ }}` dans n8n → fonctionne
- Requête testée avec deux blocs `{{ }}` dans le même champ → échoue systématiquement, y compris après rechargement de la page n8n

Cause isolée : n8n échoue silencieusement quand un champ contient deux blocs d'expression séparés, même si chacun est valide isolément. Corrigé en regroupant toute la logique dans un seul bloc, construit par concaténation JavaScript.

### 3. Validation et documentation
Modification appliquée et validée directement dans l'éditeur n8n (auto-sauvegarde serveur immédiate à chaque "Test step"), resynchronisée dans le fichier local via `pull`. Fondateur réécrit intégralement en V1.18 (D77, D78, section 10decies) et pushé sur GitHub. Snapshot `D78_gmail_fenetre_48h_valide.json` créé et pushé, sur le même modèle que `D75_gmail_pipeline_valide.json`.

### 4. Point Outlook (D74)
Toujours bloqué — aucune réponse de Florian ou Wagner à ce jour. Martin a programmé un mail de relance pour lundi 9h (le mail initial du 19/09 restant sans suite un dimanche).

---

## Décisions actées

- **D77** — Un mail non lu ne compte comme "point" pour l'azimut Boîte mail que s'il a moins de 48h ; le principe "reçu aujourd'hui" (D72) reste inchangé et s'additionne en OR.
- **D78** — Toute expression n8n combinant plusieurs valeurs dynamiques dans un même champ doit tenir dans un seul bloc `{{ }}`, construit par concaténation JavaScript si nécessaire — jamais deux blocs `{{ }}` séparés dans le même champ (échec silencieux confirmé empiriquement).

---

## Livrables produits

| Fichier / Élément | Nature | État |
|---|---|---|
| `docs/PERIMETER_DOCUMENT_FONDATEUR_V1_18.md` | Fondateur mis à jour (D77, D78, 10decies) | ✅ Pushé sur GitHub |
| `n8n-workflows/D78_gmail_fenetre_48h_valide.json` | Snapshot workflow validé | ✅ Pushé sur GitHub |
| Requête Gmail corrigée (node "Get many messages Gmail") | Pipeline en production | ✅ Validée en exécution réelle |
| Branche Outlook (D74) | Pipeline | ⚫ Toujours bloquée — relance envoyée lundi 9h |

---

## Commandes Terminal produites

```bash
# Synchroniser le fichier local sur l'état réel du serveur n8n (à faire avant toute inspection ou tout prompt Cursor sur ce workflow)
cd ~/Documents/GitHub/perimeter/n8n-workflows && ./sync_workflow.sh xkS15S1PWCDYULRv pull
```

```bash
# Créer un instantané figé (non affecté par le .gitignore) d'un état de workflow validé, et le pousser
cp xkS15S1PWCDYULRv.json [NOM_SNAPSHOT].json && git add [NOM_SNAPSHOT].json && git commit -m "[message]" && git push
```

---

## Pièges découverts

- **Deux blocs d'expression `{{ }}` dans le même champ de paramètre n8n → échec silencieux** (item fantôme `alwaysOutputData`, aucune erreur visible), même quand chaque expression est individuellement valide. Solution : tout regrouper dans un seul bloc, via concaténation JavaScript. Distinct du piège déjà connu sur `DateTime.now()` (D62) — deux limitations différentes du même moteur d'expression.
- **Une modification faite dans l'éditeur n8n (via "Test step" ou autre) est auto-sauvegardée côté serveur immédiatement** — il n'existe pas de mode "tester sans sauvegarder" dans l'UI n8n. Reconfirmé cette session après l'avoir déjà noté le 20/09 : à ne pas oublier, ça change la manière de tester en toute sécurité (toujours vérifier l'état réel après coup plutôt que de supposer qu'un test est neutre).

---

## Prochaines étapes

1. **Vérifier la réponse de Florian ou Wagner** (consentement admin Outlook, D74) — relance programmée lundi 9h
2. Une fois débloqué : reconnecter le credential Outlook, retester isolé avant de construire la boucle mail Outlook
3. Chantier dédié — lieu Outlook/Monday (D69), à faire un jour de semaine avec de vraies données
4. Seuils (D15) et constantes k (D26) pour les 9 nouveaux azimuts
5. Source fiable pour l'azimut "Mémoire & connaissance" (D55)

---

*Session 20 septembre 2026 · Perimeter · Mac Maison*
