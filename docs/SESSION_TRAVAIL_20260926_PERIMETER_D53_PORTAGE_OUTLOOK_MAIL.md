# Session de travail — Perimeter — Portage D80, logo, déblocage Outlook et branche Outlook mail

*26 septembre 2026 (samedi, 12h40 → 16h45) — Mac Maison — suite de la session D53 du 20/09 (soir)*

---

## Contexte de départ

Prompt de continuation du 20/09 : sept étapes, dans l'ordre logique/constructif/sécurisé — porter le cercle validé dans le prototype réel, verser le logo, vérifier le consentement admin Outlook (D74), reconnecter et retester, puis D69, D15/D26, D55.

Protocole de démarrage appliqué (clone du repo, fondateur V1.19 + récap D53 lus, canvas de design relu). **Écart détecté immédiatement** : le prototype sur `main` était encore en direction D24 (IBM Plex, anciens tokens, tremblé), alors que le récap et le fondateur donnaient D79 comme appliqué. Le travail existait, non commité, sur le Mac de Martin. **Dérive de continuité relevée** : le prompt de continuation avait perdu deux points du récap (maquette thème sombre D81, sort de l'Option B).

---

## Déroulé

1. **Sauvegarde du travail D79** — `git status` sur le Mac : prototype modifié, 0 occurrence d'IBM Plex. Commité tel quel (`7ba1ce1`) avant tout autre travail.
2. **Portage D80 dans le prototype** (prompt Cursor) — cercle hairline irrégulier, 15 points (taille = charge), grain global, légende interactive, séquences 1-4 sur le même primitif, Inter 700 chargé. Arbitrage séquence 4 : **option B** retenue par Martin (tout noir, seule la taille des points montre l'allègement). Prompt collé tronqué la première fois (« Ne touche à rien d'autre » absent) — contrôlé par `git status` avant commit.
3. **Affinages légende** (demandes de Martin) — tri par charge décroissante (rang), colonne %, alignement des colonnes, format de pourcentage harmonisé (espace fine insécable), stepper sans `box-shadow` (`0d01f35`, `0f3c6e5`).
4. **Logo** — 2 PNG reçus (1254 px, fond papier, sans transparence). Question de Martin : « PNG vers SVG, ça n'existe pas en CLI ? » → vectorisation faite en session : cercle et point reconstruits géométriquement (mesures sur les PNG), mot vectorisé via potrace (deux itérations : la première fusionnait les lettres, corrigée), SVG `currentColor`, variante pleine en réserve réelle. Aperçu clair/sombre validé. Versés dans `design/logo/` (`caa1f6b` SVG, `278bbd1` PNG — tailles vérifiées à l'octet).
5. **D74 levé** — Florian a accordé le consentement admin. Vérification Azure pas à pas (Enterprise Applications › Autorisations) : 18 scopes en « Consentement administrateur ». Credential reconnecté sans écran de consentement ; « TEST Mail.Read » lit un vrai mail.
6. **Branche Outlook mail** — mini-plan validé ; D73 étendu à Outlook (**D82**, « oui » de Martin). À la demande de Martin (« tu ne peux pas faire directement un JSON ? »), node livré en JSON à coller — et bascule vers un **HTTP Request Graph** plutôt que le node natif (**D83**) : Boîte de réception par nom standard, en-têtes accessibles, un seul `{{ }}`. Test isolé concluant, branchement dans le canevas, quatrième boucle dans « Préparer signaux Ollama » (Cursor), push, test en amont d'Ollama : 2 items `outlook_mail`, signal newsletter présent.
7. **Incident Google** — credential « Google Calendar account » expiré (app OAuth probablement en « Testing », jetons à 7 jours). Reconnecté.
8. **Régression découverte** — premier test complet : 15 signaux → 1 seul parsé. Cause : « Parser réponse Ollama » revenu en mode « All Items », correction D69 perdue depuis le 19/09 (absente des snapshots D69, D78, D74). Aucun point en base depuis le 18/09. Corrigé dans l'interface + pull immédiat (règle **D87**).
9. **Validation de bout en bout** — 15 → 15 → 2 retenus → 2 lignes `moteur_ollama_outlook_mail` en base. La newsletter industrie.school classée `management_equipe` urgence 3 → décision **D84** de Martin. Snapshot commité (`d254e89`), vérifié sans `pinData` ni contenu de mail.

---

## Décisions actées cette session

- **D82** — D73 étendu à Outlook : en-tête `List-Unsubscribe` → signal newsletter transmis à Ollama.
- **D83** — Lecture mail Outlook via HTTP Request Microsoft Graph (`/me/mailFolders/inbox/messages`) avec le credential Outlook existant ; amende D71 pour la lecture mail. Fenêtre D72/D77 : 48 h côté Graph, « aujourd'hui OU non lu » côté code. `$top=100`, `onError: continueRegularOutput`, source `moteur_ollama_outlook_mail`.
- **D84** — Une newsletter avec lien de désabonnement est toujours un point, urgence faible (Gmail et Outlook). Mise en œuvre reportée à la prochaine session, dans le code (pas le prompt).
- **D85** — Rendu du prototype : avant/après tout noir ; légende triée par charge, rang, colonne % ; format `formatPct` unique (U+202F) ; stepper sans ombre ; grain global.
- **D86** — Logo versionné dans `design/logo/` : PNG sources + SVG `currentColor` (compatibles D81).
- **D87** — Toute modification faite dans l'éditeur n8n est suivie immédiatement d'un `pull` ; jamais de `push` depuis un fichier local antérieur.

Document Fondateur réécrit en **V1.20**.

---

## Livrables et commits

| Commit | Contenu |
|---|---|
| `7ba1ce1` | Prototype — application D79 (travail du 20/09 resté non commité) |
| `0d01f35` | Prototype — portage D80 (15 azimuts), légende triée, stepper sans box-shadow |
| `0f3c6e5` | Prototype — colonne %, alignement, format pourcentage harmonisé |
| `caa1f6b` | `design/logo/` — 2 SVG vectoriels |
| `278bbd1` | `design/logo/` — 2 PNG sources |
| `1bf9ac1` | Snapshot n8n `D74_outlook_mail_consentement_valide.json` |
| `d254e89` | Snapshot n8n `D83_outlook_mail_pipeline_valide.json` (pipeline validé) |
| *(à commiter)* | Ce récap + `PERIMETER_DOCUMENT_FONDATEUR_V1_20.md` |

---

## Pièges découverts (à verser au carnet de pièges, prochaine version)

- **[n8n] Une modification faite dans l'interface est écrasée par le `push` suivant d'un fichier local antérieur** — sans erreur, sans trace. Cas réel : la correction D69 du Parser (18/09) perdue dès le 19/09 ; plus aucun point en base pendant 8 jours. Règle D87 : `pull` immédiat après toute modification UI.
- **[n8n] Valider un pipeline, c'est vérifier la table d'arrivée** — les tests du 20/09 s'arrêtaient à « Préparer signaux Ollama » et n'ont pas vu la chaîne cassée en aval. Toujours regarder Supabase, pas un node intermédiaire.
- **[n8n] Code node : le mode par défaut est « Run Once for All Items »** — `$json` y désigne le premier item seulement ; le node sort 1 item sans erreur. Le mode « Each Item » exige de retourner un objet, pas une liste.
- **[n8n/Outlook] Le node natif Microsoft Outlook (message › getAll) lit `/me/messages`, soit tous les dossiers**, et n'expose pas `internetMessageHeaders`. Pour la Boîte de réception seule et les en-têtes : HTTP Request sur `/me/mailFolders/inbox/messages` avec le credential prédéfini `microsoftOutlookOAuth2Api` et `$select` explicite (Graph renvoie bien les en-têtes en liste — vérifié, 44 à 54 par mail).
- **[n8n] `"pinData"` est écrit sans espace dans l'export** (`"pinData":{}`) — un `grep` sur `"pinData": {}` renvoie 0 à tort. Vérifier en parsant le JSON.
- **[Google OAuth] App en statut « Testing » → jetons expirés à 7 jours** — les credentials n8n Google (Calendar, Gmail) tombent chaque semaine. Passer l'app en « In production ».
- **[Supabase] Free tier : mise en pause après 7 jours sans activité** — prévenu par mail. Prévoir un keep-alive tant que le Tour n'est pas automatique.
- **[Azure] Le consentement administrateur peut accorder plus que demandé** (18 scopes, dont `Mail.Read`, `Contacts.ReadWrite.Shared`) — vérifier la liste réelle dans Enterprise Applications › Autorisations, pas la demande envoyée.
- **[Méthode/Git] « Appliqué » dans un récap ne veut pas dire commité** — le travail D79 est resté 6 jours sur un seul Mac. Le protocole de démarrage (lecture du fichier réel sur `main`) l'a détecté ; garder le réflexe `git status` en fin de session.
- **[Cursor] Prompt tronqué au collage** — Cursor ne reçoit pas « Ne touche à rien d'autre » (il l'a signalé lui-même : « ta question s'est coupée »). Contrôle : `git status --short` + `git diff --stat` avant tout commit.
- **[Terminal] Chemins de fichiers collés devant une commande** — zsh tente de les exécuter (`permission denied`) et s'arrête, sans effet de bord.
- **[Hazel] Les images/SVG téléchargés arrivent dans `~/Downloads/Images/Logos/`** — règle non documentée dans l'instruction Hazel du projet (qui ne couvre que `.md`, code et `.skill`).

---

## Vigilances ouvertes (non bloquantes)

- `$top=100` sans pagination sur Outlook mail (17 mails / 48 h observés).
- Scopes Azure plus larges que le principe de scope minimal.
- Condition de réversibilité D29 formellement atteinte (résumés de mails en base) — question à reposer.
- Événements Outlook « journée entière » : décalés à 02:00 et passant le filtre « aujourd'hui » la veille.
- Canvas de design : artboard principal encore titré « Option A — Anneau organique (Arrival) ».

---

## Prochaines étapes (ordre logique / constructif / sécurisé)

1. **Google OAuth en « In production »** — le credential Gmail (connecté le 20/09) expire vers le 27/09 ; sécuriser avant de construire.
2. **Keep-alive Supabase** — petit workflow n8n planifié quotidien.
3. **D84** — trancher « un point par expéditeur » et l'alignement Gmail, puis prompt Cursor (brouillon ci-dessous), push, test complet, vérification en base, snapshot.
4. **Question D29** — repo public ou privé.
5. **D53, fin** — maquette thème sombre (D81), archivage Option B, titre d'artboard.
6. **D69** — lieu Outlook/Monday, un jour de semaine avec vraies données.
7. **D15 / D26** — seuils et constantes k des 9 nouveaux azimuts.
8. **D55** — source automatique pour « Mémoire & connaissance ».

### Brouillon du prompt Cursor D84 (à ajuster selon les deux arbitrages)

```
Fichier unique : n8n-workflows/xkS15S1PWCDYULRv.json. Ne modifier que le node "Parser réponse Ollama" (mode runOnceForEachItem, à conserver).

Après JSON.parse de la réponse Ollama, et avant le return :
- Lire original.signal_texte. Si il contient "Signal newsletter/pub détecté" (Gmail ou Outlook) :
  - forcer est_un_point = true, azimut = "boite_mail", urgence = 1, urgence_label = "faible" ;
  - action_suggeree = "Se désabonner" + " — " + le lien extrait du signal (texte après "lien de désabonnement : ") ;
  - conserver le resume rédigé par Ollama.
  - [SI "un point par expéditeur" validé] remplacer event_id par "newsletter:" + adresse de l'expéditeur (extraite de la ligne "Expéditeur :" du signal, en minuscules, sans nom affiché).
- Sinon : aucun changement.
Retourner toujours un objet { json: {...} } (mode Each Item).

En fin de tâche, donne-moi ton analyse : est-ce que quelque chose te semble risqué ou incomplet dans ce que tu viens de faire ?

Ne touche à rien d'autre.
```

---

## Prompt de continuation

```
Bonjour JARVIS ! On reprend Perimeter — suite de la session du 26/09.

Ce qui s'est passé : prototype réel à jour (D79 enfin commité, cercle D80 porté,
légende triée par charge avec %, D85) ; logo versionné dans design/logo/ en PNG + SVG
currentColor (D86). Consentement admin Outlook accordé par Florian (D74 levé) ;
branche Outlook mail construite en HTTP Request Microsoft Graph (D83), signal
newsletter étendu à Outlook (D82). Régression découverte : le Parser Ollama avait
perdu sa correction D69 depuis le 19/09 (aucun point en base pendant 8 jours) —
corrigée, règle D87 (pull immédiat après toute modif dans l'interface n8n).
Pipeline validé de bout en bout : 2 points moteur_ollama_outlook_mail en base.
Décision de Martin : une newsletter avec lien de désabonnement est toujours un
point, urgence faible (D84) — à implémenter. Fondateur réécrit en V1.20.

Document de référence : PERIMETER_DOCUMENT_FONDATEUR_V1_21.md + récap
SESSION_TRAVAIL_20260926_PERIMETER_D53_PORTAGE_OUTLOOK_MAIL.md (repo
RealCoolclint/perimeter, branche main).

Prochaines étapes, dans l'ordre logique/constructif/sécurisé :
1. [FAIT le 26/09 au soir — D88] App OAuth Google en production.
2. Keep-alive Supabase (free tier en pause après 7 jours d'inactivité).
3. D84 : trancher "un point par expéditeur" et l'alignement Gmail sur l'en-tête
   List-Unsubscribe, puis prompt Cursor (brouillon dans le récap), test complet,
   vérification en base.
4. Reposer la question D29 (repo public) — résumés de mails désormais en base.
5. D53 fin : maquette thème sombre (D81), archiver l'Option B, retitrer l'artboard.
6. D69 (lieu Outlook/Monday), un jour de semaine avec vraies données.
7. Seuils (D15) et constantes k (D26) des 9 nouveaux azimuts.
8. Source fiable pour "Mémoire & connaissance" (D55).

Bonne session !
```

---

## Addendum — soirée (19h50 → 20h45) : app OAuth Google en production (D88)

Option A retenue par Martin (plutôt que des reconnexions hebdomadaires).

1. Branding complété (nom `perimeter`, e-mails d'assistance et développeur) — bouton « Publier » toujours grisé.
2. Cause : Google exige aussi page d'accueil, règles de confidentialité et domaine autorisé (non marqués obligatoires dans l'interface).
3. Nouveau repo public `RealCoolclint/perimeter-site`, créé par Martin ; `index.html` + `privacy.html` rédigés et poussés par JARVIS (`de604d8`), identité Perimeter (ivoire, Inter, logo hairline SVG) ; GitHub Pages activé par Martin.
4. URLs renseignées dans Branding, domaine `realcoolclint.github.io` accepté sans preuve de propriété → « Publier l'application » actif → **« En production »**.
5. Bandeau « doit être validée » ignoré volontairement ; aucun logo téléversé.
6. Credentials « Google Calendar account » et « Gmail account » reconnectés (écran « application non vérifiée » → Paramètres avancés → Accéder).

**Décision : D88.** Fondateur réécrit en **V1.21**. Étape 1 de la liste des prochaines étapes : **faite**.

**Pièges ajoutés au carnet (V53) :** publication OAuth externe bloquée tant que page d'accueil, confidentialité et domaine autorisé manquent, sans que l'interface les marque obligatoires ; téléverser un logo sur l'écran de consentement déclenche une validation Google obligatoire ; les jetons émis en mode Test gardent leur expiration à 7 jours après publication — reconnecter.

**Prompt de continuation — mise à jour :** retirer l'étape 1 (faite) ; le document de référence devient `PERIMETER_DOCUMENT_FONDATEUR_V1_21.md`.

---

*Session 26 septembre 2026 · Perimeter · Mac Maison (martinpavloff)*
