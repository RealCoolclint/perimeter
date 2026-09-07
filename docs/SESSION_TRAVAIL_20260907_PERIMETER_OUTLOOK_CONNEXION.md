# Session de travail — Perimeter — 07/09/2026

*Connexion Outlook (D45) établie de bout en bout*

---

## Contexte de reprise

Document fondateur à jour en entrée de session : `PERIMETER_DOCUMENT_FONDATEUR_V1_10.md`, D44 dernière décision actée (28/08/2026). Deux chantiers prioritaires identifiés en prompt de continuation :

1. Retraiter le jour du 22/09/2026 (bloqué, tournage pas encore réalisé)
2. Chantier Outlook (app registration Azure)

Le point 1 restant bloqué par le calendrier réel, la session s'est portée sur le point 2.

---

## Ce qui a été fait

### Azure — App registration

- Création de l'app **"Perimeter Outlook Sync"** sur le tenant Azure L'Etudiant (single-tenant, "Comptes dans cet annuaire d'organisation uniquement")
- Client ID : `2911bc2b-d055-42a5-90a2-699a3bf0a807`
- Tenant ID : `6888b368-f0ef-4195-8a80-c82ecb60a8f7`
- Client secret créé (description "N8N", expiration 06/09/2028)
- Permissions API déléguées configurées : `Calendars.Read`, `offline_access`, `User.Read`

### n8n — Credential OAuth2

- Credential "Microsoft Outlook account" (type Microsoft Outlook OAuth2 API) créé et connecté avec succès
- Connexion testée par un mini-workflow (déclencheur manuel + node "Get Many Events", limite 5) : **5 événements réels du calendrier de Martin remontés**, données confirmées non génériques (sujets, horaires, participants, organisateur cohérents)

### Pièges rencontrés et résolus (à retenir)

1. **Docker non lancé** — `docker ps` vide, résolu par `open -a Docker` (aucun conteneur listé ensuite avec `-a` non plus, à surveiller si besoin de relancer n8n un jour — voir "Points ouverts")
2. **Confusion Client ID / ID de secret** — l'ID de secret Azure (`84f24754-...`) a été collé par erreur dans le champ Client ID de n8n. Le vrai Client ID est visible sur la page "Vue d'ensemble" de l'app, pas sur la page "Certificats & secrets".
3. **Endpoint `/common/` invalide pour une app single-tenant** — erreur AADSTS50194. Correction : remplacer `common` par l'ID de tenant dans les deux URLs (Authorization URL et Access Token URL) du credential n8n.
4. **Consentement admin requis même pour des scopes minimaux** — le tenant L'Etudiant bloque le consentement utilisateur standard, quel que soit le niveau de sensibilité des scopes demandés (politique tenant-wide, pas liée à la largeur des permissions). Martin a choisi de traiter ça lui-même via le formulaire d'approbation plutôt que de passer par un ticket IT formel — connexion obtenue sans intervention de Sébastien.

### Sécurité

- Les trois secrets (Client ID, Tenant ID, Client Secret) stockés dans Bitwarden par Martin, dans un item dédié "Perimeter Outlook Sync — Azure App Registration". Jamais versionnés en clair dans le repo ou dans ce récap.

---

## Décision actée

**D45** — voir Document Fondateur V1.11.

---

## Points ouverts / suite

- **Pipeline de lecture calendrier à construire** : le credential est validé, mais aucun workflow n8n de production ne consomme encore Outlook comme deuxième source pour le poids journée (D16). Reste à concevoir la fusion avec la source Google Calendar existante.
- **Fuseau horaire** : les `dateTime` renvoyés par Microsoft Graph sont en UTC sans décalage. À convertir en Europe/Paris avant tout calcul ou affichage, sous peine d'un décalage systématique de 2h (heure d'été) ou 1h (heure d'hiver).
- **22/09/2026** — toujours en attente du tournage réel pour retraitement (inchangé depuis le 28/08).
- **`docker ps -a`** — jamais confirmé pendant la session si un conteneur n8n existait à l'arrêt ou si le service tournait autrement (peut-être n8n installé en local hors Docker). Point mineur, à clarifier si un problème de démarrage se reproduit.

---

## Prompt de continuation

```
On reprend le travail sur Perimeter.
Document fondateur à jour : PERIMETER_DOCUMENT_FONDATEUR_V1_11.md (repo perimeter, branche main), D45 dernière décision actée.
Ce qui s'est passé le 07/09/2026 :
- D45 : connexion Outlook OAuth2 établie de bout en bout (app registration Azure single-tenant
  + credential n8n), testée avec succès sur des données réelles du calendrier de Martin.
  Secrets stockés dans Bitwarden. Deux pièges documentés à ne pas reproduire : endpoint /common/
  invalide pour une app single-tenant (utiliser l'endpoint spécifique au tenant), et confusion
  possible entre Client ID et ID de secret Azure.
Prochaines étapes prioritaires :
1. Construire le pipeline n8n de lecture du calendrier Outlook comme deuxième source pour le
   poids journée (D16), avec conversion UTC → Europe/Paris
2. Retraiter le jour du 22/09/2026 une fois le tournage réalisé
```
