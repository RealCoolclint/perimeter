# Session de travail — 20 septembre 2026
## Perimeter — Pipeline Gmail construit et validé (D48), fenêtre D72 à retrancher

*Session de suite directe de celle du 19-20/09 (cadrage D48, blocage Azure D74). Protocole de démarrage appliqué (git pull, lecture fondateur V1.16 + récap du 19/09), aucune dérive détectée. La branche Outlook restant bloquée (consentement admin en attente), la session s'est concentrée sur la branche Gmail perso, indépendante du blocage.*

---

## Chantiers traités

### 1. Credential Gmail OAuth2
Création de l'app "Google Auth Platform" côté Google Cloud (nouvelle interface, tabs Présentation/Branding/Audience/Clients/Accès aux données). Scopes ajoutés manuellement (bypass du navigateur à 83 pages) via "Accès aux données → Ajouter manuellement des niveaux d'accès". Redirect URI : `http://localhost:5678/rest/oauth2-credential/callback` (même schéma que le credential Outlook, D45). Credential connecté et testé côté n8n (`rgxu7p8G3nONoTCp` / "Gmail account").

### 2. Découverte de la forme réelle des données Gmail
Le node natif Gmail (`n8n-nodes-base.gmail`) a un scope fixe et non éditable, dans la même logique que le node Outlook (`gmail.labels`, `gmail.compose`, `mail.google.com`, `gmail.modify`, etc.) — accepté sciemment, décision actée en D75.

La doc officielle n8n sur le toggle "Simplify" s'est révélée ambiguë par rapport au comportement réel. Plutôt que de s'y fier, test empirique direct : la vraie forme des données retournées ne correspond pas à ce qui était supposé au départ (`payload.headers` n'existe pas). La forme réelle : `headers` est un objet plat à clés minuscules, `subject`/`date`/`from`/`text`/`labelIds` sont déjà tout en haut, déjà parsés proprement par n8n.

### 3. Construction du pipeline (branche Gmail)
Node "Get many messages Gmail" ajouté et câblé en amont de "Préparer signaux Ollama". Boucle Gmail ajoutée au Code node existant (celui qui pioche déjà par nom dans Google Calendar et Outlook) : extraction sujet/expéditeur/date/aperçu, détection newsletter via `labelIds.includes('CATEGORY_PROMOTIONS')` + en-tête `List-Unsubscribe` (D73), fenêtre D72 implémentée via requête Gmail (`in:inbox (is:unread OR after:<minuit Paris en epoch>)`).

Six allers-retours Cursor successifs pour corriger, dans l'ordre : credential vide, `alwaysOutputData` manquant, requête de date qui excluait "aujourd'hui", `returnAll` non capé, `DateTime.now()` invalide en expression n8n (→ `$now`), absence de garde contre l'item fantôme, forme réelle des champs (réécriture complète de la boucle), fallback `snippet` pour les mails HTML sans texte brut.

### 4. Bug transverse découvert : signal fantôme (`alwaysOutputData`)
Quand un node n'a aucun résultat, `alwaysOutputData: true` fait quand même passer un item vide `{}` en aval, pour ne pas bloquer le workflow. Ce comportement, déjà présent sur les nodes Google et Outlook depuis leur création, n'avait jamais été gardé côté Code node — un signal creux ("Événement sans titre") partait donc systématiquement vers Ollama à chaque exécution sans résultat réel. Découvert en construisant la garde sur la boucle Gmail neuve, puis reproduit à l'identique sur les boucles Google et Outlook préexistantes. Garde `if (!id) continue;` ajoutée aux trois boucles.

### 5. Validation end-to-end
Exécution réelle confirmée : plus aucun signal fantôme Google/Outlook, uniquement des signaux Gmail réels (newsletter Nuclever avec lien de désabonnement capté correctement, etc.). Volume observé : 42 messages sur un run (plafond de sécurité `limit: 50` presque atteint), remontant jusqu'au 18/09 18h19 — bien au-delà d'"aujourd'hui" à cause du backlog de non-lus.

---

## Décisions actées

- **D75** — Node natif Gmail retenu malgré son scope large et fixe (`mail.google.com`, `gmail.modify`, etc.), même logique que D71 sur Outlook : cohérence et rapidité de mise en œuvre plutôt qu'un scope minimal sur-mesure.
- **D76** — Garde systématique contre l'item fantôme `alwaysOutputData` ajoutée sur les trois boucles de "Préparer signaux Ollama" (Google, Outlook, Gmail). Règle à appliquer à toute future source ajoutée à ce node.

## Décision ouverte — non tranchée cette session

**D72 (fenêtre de lecture) fonctionne mais révèle un effet de bord** : "non lu, peu importe la date" remonte tout le backlog, pas seulement les mails du jour. Trois options posées à Martin en fin de session (A — fenêtre glissante sur le non-lu, ex. 48h ; B — garder tout le backlog mais ajouter un champ d'ancienneté traité différemment par Ollama ; C — capper strictement le nombre sans logique temporelle). **Aucune réponse donnée avant la clôture — à trancher en priorité à la prochaine session.**

---

## Livrables produits

| Fichier / Élément | Nature | État |
|---|---|---|
| Credential Gmail OAuth2 (n8n) | Authentification | ✅ Connecté et validé |
| Node "Get many messages Gmail" + boucle Gmail dans "Préparer signaux Ollama" | Pipeline | ✅ Construit, testé en exécution réelle |
| Garde `alwaysOutputData` (3 boucles) | Fix bug transverse | ✅ En place, validé |
| `docs/PERIMETER_DOCUMENT_FONDATEUR_V1_17.md` | Fondateur mis à jour (D75, D76, section fenêtre Gmail ouverte) | 🟡 À produire (prompt Cursor fourni) |
| `n8n-workflows/D75_gmail_pipeline_valide.json` | Snapshot du workflow validé | 🟡 À créer (commande fournie) |
| Branche Outlook (D74) | Pipeline | ⚫ Toujours bloquée — consentement admin en attente |

---

## Pièges découverts (carnet de pièges)

- **Une modification manuelle dans l'UI n8n est auto-sauvegardée côté serveur immédiatement** — pas besoin (et pas moyen) de "tester sans sauvegarder". Si un champ est modifié en live pour tester, et que le fichier local (source des prompts Cursor) contient déjà la bonne valeur non encore poussée, ne PAS faire de `pull` avant le prochain `push` — un `pull` importerait la valeur de test dans le fichier local et écraserait la bonne valeur.
- **La doc officielle n8n sur le toggle "Simplify" d'un node (ex. Gmail) ne reflète pas forcément fidèlement la forme réelle des données retournées.** Toujours valider par un test réel avant d'écrire le code qui consomme ces données, ne jamais coder à l'aveugle sur la doc seule.
- **`alwaysOutputData: true` sur un node sans résultat envoie un item vide en aval** — si un Code node en aval traite plusieurs sources par nom (`$('Node').all()`), CHAQUE source avec ce paramètre a besoin de sa propre garde (`if (!id) continue;`), pas seulement la dernière ajoutée. Vérifier systématiquement les sources existantes quand on ajoute une nouvelle source au même pattern.
- **Un scope OAuth2 "non lu" côté Gmail peut remonter un backlog de plusieurs jours/semaines**, pas juste "aujourd'hui" — à anticiper dès le cadrage produit d'une fenêtre basée sur `is:unread`, pas seulement au moment du test.

---

## Prochaines étapes

1. **Trancher la fenêtre Gmail (D72)** — choisir entre les options A/B/C ci-dessus, priorité de la prochaine session
2. Vérifier si Florian/Wagner ont validé le consentement admin Outlook (D74, toujours bloqué)
3. Une fois débloqué : reconnecter le credential Outlook, retester isolé avant de construire dessus
4. Chantier dédié lieu Outlook/Monday (D69), reporté à un jour de semaine avec vraies données
5. Seuils (D15) et constantes k (D26) pour les 9 nouveaux azimuts
6. Source fiable pour "Mémoire & connaissance" (D55)

---

*Session 20 septembre 2026 · Perimeter · à distance (Claude)*
