# Session de travail — 19-20 septembre 2026
## Perimeter — Cadrage D48 (pipeline Boîte mail), blocage consentement Azure

*Session de suite directe de celle du 19/09 (diagnostic lieu Outlook, rate limit Monday) — protocole de démarrage appliqué (git pull, lecture fondateur V1.15 + récap du jour), aucune dérive détectée. Session hybride : cadrage produit puis diagnostic technique approfondi, débouchant sur un blocage organisationnel non résolu.*

---

## Chantiers traités

### 1. Cadrage du chantier D48 (pipeline Boîte mail)

Avant tout code, mini-plan soumis et validé point par point avec Martin :
- **Périmètre** : les deux boîtes mail (Outlook L'Étudiant + Gmail perso `pavloffmartin@gmail.com`), pas seulement la pro — nécessaire puisque Finances perso, Loisirs et Domicile dépendent aussi de la Boîte mail comme source (section 3 du fondateur).
- **Fenêtre temporelle** : union de deux critères — mails reçus aujourd'hui **OU** non lus (peu importe la date), pour ne rien laisser passer. INBOX uniquement (exclut le spam de fait).
- **Détection newsletter/pub** : sur Gmail perso seulement, via le label natif `CATEGORY_PROMOTIONS` et l'en-tête `List-Unsubscribe` — signal transmis tel quel à Ollama, qui propose un désabonnement en `action_suggeree`. Pas de logique de détection à construire, l'information existe déjà côté Gmail.
- **Architecture retenue** : node natif "Microsoft Outlook" de n8n plutôt qu'un contournement scope-minimal (credential OAuth2 générique + HTTP Request direct sur Graph) — plus rapide à mettre en œuvre, accepté en connaissance de cause malgré un scope plus large que la pratique jusqu'ici (D45).

### 2. Diagnostic du blocage Mail.ReadWrite (le gros de la session)

Inspection du workflow n8n existant (`n8n-workflows/D70_retry_monday_rate_limit.json`) pour situer l'accroche du nouveau chantier : node "Préparer signaux Ollama" identifié comme point d'entrée naturel (transforme déjà chaque signal calendrier en `signal_texte` avant l'appel Ollama), azimut `boite_mail` déjà présent dans le schéma JSON strict (D66) — aucune modification de schéma nécessaire.

Ajout de `Mail.Read` seul dans l'app Azure "Perimeter Outlook Sync" (scope minimal initial) → 403 Forbidden persistant sur un node de test isolé, malgré plusieurs reconnexions du credential n8n. Recherche de la cause réelle plutôt que de re-tenter à l'aveugle : le node natif "Microsoft Outlook" de n8n a une liste de scopes fixe, non éditable dans l'interface, qui ne demande jamais `Mail.Read` seul mais un bloc de 11 scopes ([confirmé via le code source officiel n8n](https://github.com/n8n-io/n8n/blob/master/packages/nodes-base/credentials/MicrosoftOutlookOAuth2Api.credentials.ts)). Les scopes manquants ajoutés en trois passes successives (`Contacts.Read`, `Contacts.ReadWrite`, `Calendars.Read.Shared`, `Calendars.ReadWrite`, `Mail.ReadWrite`, `Mail.ReadWrite.Shared`, `Mail.Send`, `Mail.Send.Shared`, `MailboxSettings.Read`) pour matcher exactement la demande du node.

403 toujours persistant après reconnexion complète (y compris test en navigation privée, avec authentification + double identification Authenticator réelles). Vérification poussée dans Azure — pas sur la fiche "App registrations" (déclarative) mais sur la fiche "Enterprise Applications" (état réel du consentement) : l'onglet "Consentement de l'utilisateur" est **vide**, y compris pour les 4 scopes historiques de D45. Conclusion : le tenant L'Étudiant interdit tout consentement utilisateur sur cette app, sans exception et sans message d'erreur visible — les 4 scopes de D45 avaient en réalité été accordés par un administrateur réel, jamais en self-service comme le fondateur le supposait jusqu'ici.

Le bouton "Accorder un consentement d'administrateur" est grisé pour le compte de Martin (pas de rôle admin sur ce tenant). Décision : demander l'intervention d'un administrateur plutôt que chercher un contournement technique. Email rédigé (ton volontairement non technique, mention du développement assisté par Cursor/Claude, cadre l'app comme un outil perso sans mémoire ni donnée sur d'autres personnes) à l'attention de Florian et Wagner (service informatique), sans les nommer individuellement dans le corps du message.

---

## Décisions actées

- **D71** — Architecture du chantier Boîte mail actée : deux boîtes couvertes (Outlook pro + Gmail perso), node natif Microsoft Outlook retenu malgré son scope large et fixe, au lieu d'un contournement scope-minimal.
- **D72** — Fenêtre de lecture mail : union (reçus aujourd'hui OU non lus), INBOX uniquement.
- **D73** — Détection newsletter/pub sur Gmail perso uniquement, via label `CATEGORY_PROMOTIONS` + en-tête `List-Unsubscribe`, transmise à Ollama sans logique de détection dédiée.
- **D74** — Blocage tenant identifié et documenté : consentement utilisateur interdit sur "Perimeter Outlook Sync", validation admin requise. Email envoyé le 19/09/2026 à Florian et Wagner.

---

## Livrables produits

| Fichier / Élément | Nature | État |
|-------------------|--------|------|
| `docs/PERIMETER_DOCUMENT_FONDATEUR_V1_16.md` | Document fondateur mis à jour (D71-D74, section 10octies, section 11) | ✅ À pousser (commande ci-dessous) |
| Email à Florian/Wagner (service informatique) | Demande de consentement admin | 🟡 Rédigé, à envoyer par Martin |
| Scopes Azure (`Mail.ReadWrite` et 8 associés) | Ajoutés à l'app "Perimeter Outlook Sync" | ✅ En place, non consentis |
| Nodes n8n pour la lecture mail (Outlook + Gmail) | Code du pipeline | ⚫ Non commencé — bloqué / dépendant du credential Gmail |

---

## Commandes Terminal produites

```bash
# Pousser le document fondateur mis à jour
cd ~/Documents/GitHub/perimeter
git add docs/PERIMETER_DOCUMENT_FONDATEUR_V1_16.md docs/SESSION_TRAVAIL_20260919_PERIMETER_D48_CADRAGE_BLOCAGE_AZURE.md
git commit -m "V1.16 : cadrage D48 (pipeline Boite mail), blocage consentement Azure documente (D71-D74)"
git push
```

---

## Pièges découverts

- **Le node natif "Microsoft Outlook" de n8n a une liste de scopes OAuth2 fixe et non éditable dans l'interface** (`Contacts.Read`, `Contacts.ReadWrite`, `Calendars.Read`, `Calendars.Read.Shared`, `Calendars.ReadWrite`, `Mail.ReadWrite`, `Mail.ReadWrite.Shared`, `Mail.Send`, `Mail.Send.Shared`, `MailboxSettings.Read`, `openid`, `offline_access`) — impossible de le limiter à un scope minimal comme `Mail.Read` seul. Pour un scope minimal, il faut contourner ce node avec un credential OAuth2 générique + HTTP Request direct sur Microsoft Graph.
- **Un décalage entre le scope demandé par n8n et le scope réellement enregistré sur l'app Azure produit un 403 Forbidden silencieux et permanent**, sans indication claire de la cause — vérifier d'abord la liste exacte de scopes demandés par le credential (code source n8n) avant de chercher ailleurs.
- **La fiche "App registrations" d'Azure (déclarative, ce que l'app peut demander) est différente de la fiche "Enterprise Applications" (état réel du consentement accordé)** — pour diagnostiquer un problème de consentement, toujours vérifier la seconde, onglets "Consentement administrateur" / "Consentement de l'utilisateur", jamais se fier uniquement à la première.
- **Un tenant peut bloquer totalement le consentement utilisateur sans jamais afficher de message d'erreur explicite** — la reconnexion se termine "normalement" (retour à l'état "connecté"), y compris après une authentification complète avec 2FA, mais aucun nouveau scope n'est réellement accordé. Seule la vérification directe dans "Enterprise Applications → Permissions → Consentement de l'utilisateur" révèle le blocage.

---

## Prochaines étapes

1. Attendre le clic d'un administrateur (Florian ou Wagner) sur "Accorder un consentement d'administrateur pour L'Etudiant" (app "Perimeter Outlook Sync")
2. Une fois débloqué : reconnecter le credential "Microsoft Outlook account" dans n8n, retester avec le node isolé ("Get many messages", limite 1) avant de construire quoi que ce soit dessus
3. Créer le credential Gmail perso (OAuth2, scope `gmail.readonly`) — non bloqué, indépendant du point 1, à faire dès la prochaine session
4. Une fois les deux credentials validés : prompt Cursor unique pour construire les nodes de lecture mail (Outlook + Gmail), la préparation des signaux (avec détection newsletter/pub côté Gmail), et le Merge vers "Appel Ollama"
5. Chantier dédié lieu Outlook/Monday (D69) — toujours reporté à un jour de semaine avec de vraies données
6. Seuils (D15) et constantes k (D26) pour les 9 nouveaux azimuts
7. Source fiable pour "Mémoire & connaissance" (D55)

---

*Session 19-20 septembre 2026 · Perimeter · à distance (Claude)*
