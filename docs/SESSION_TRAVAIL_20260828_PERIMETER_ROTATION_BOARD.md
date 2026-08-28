# Session de travail — Perimeter — 28 août 2026

## Rotation annuelle du board Monday

### Contexte
Le board Monday utilisé par le pipeline Suivi Présentiel/TT (D33) tourne chaque année au 8 octobre — Martin duplique manuellement le board actuel (structure seule, sans les items) et archive l'ancien. Le numéro de board était codé en dur à deux endroits dans le workflow n8n `PERIMETER_MANAGEMENT_EQUIPE_PRESENTIEL_TT`, avec un risque réel d'oubli d'un des deux lors de la rotation.

### D43 — Centralisation du board ID
Ajout d'un node de config unique (`Config Board ID Saison`, type Code) en tête du workflow. Les deux occurrences codées en dur (node Monday natif `Get items item by column value (Télétravail)` et requête GraphQL `Monday GraphQL page 1`) référencent désormais ce node via expression (`$('Config Board ID Saison').first().json.board_id`). Mise à jour annuelle : éditer cette seule valeur.

**Point de méthode à retenir** : plusieurs allers-retours ont été nécessaires suite à des erreurs de collage de blocs JSON individuels (mauvais bloc collé deux fois, nodes dupliqués, connexions cassées). La correction finale a été livrée sous forme de **fichier de workflow complet** (tous les nodes + connexions), généré et vérifié par script avant transmission — méthode à privilégier d'emblée pour toute modification de workflow n8n existant, plutôt que des blocs de nodes individuels.

### D44 — Rappel automatique (sans automatisation de la rotation elle-même)
Question posée : automatiser entièrement la rotation (duplication + archivage via l'API Monday, mutations `duplicate_board` / `archive_board` confirmées existantes) ? Décision de Martin : non — l'archivage d'un board est une action quasi irréversible pour toute l'équipe, jugée trop sensible pour une exécution automatique sans validation humaine.

Solution retenue : rappel seul. Nouveau workflow n8n dédié `PERIMETER_RAPPEL_ROTATION_BOARD` :
- Schedule Trigger quotidien (8h)
- Code node calculant le dernier jour ouvré avant le 8 octobre de l'année en cours (gère les week-ends, ne gère pas les jours fériés — limite connue et acceptée)
- Envoi d'un email de rappel (node `emailSend`, credential SMTP) listant les 3 étapes manuelles : dupliquer le board, archiver l'ancien, mettre à jour le node `Config Board ID Saison`

**Chantier annexe** : création d'un credential SMTP Gmail dans n8n via mot de passe d'application Google (l'OAuth2 Gmail natif de n8n self-hosted nécessite un projet Google Cloud Console, jugé disproportionné pour un email annuel). Testé et fonctionnel.

## Livrables
- `n8n-workflows/PERIMETER_MANAGEMENT_EQUIPE_PRESENTIEL_TT.json` — mis à jour (D43), importé et testé par Martin (exécution réussie)
- `n8n-workflows/PERIMETER_RAPPEL_ROTATION_BOARD.json` — nouveau workflow, importé et publié par Martin
- `docs/PERIMETER_DOCUMENT_FONDATEUR_V1_10.md` — D43, D44 intégrées ; sections 10ter et 11 mises à jour

## Prochaines étapes
1. Retraiter le jour du 22/09/2026 une fois le tournage réalisé
2. Chantier Outlook (app registration Azure)
3. Vérifier à l'automne que le rappel email part bien le jour attendu (première exécution réelle du nouveau workflow)

## Prompt de continuation

```
On reprend le travail sur Perimeter.
Document fondateur à jour : PERIMETER_DOCUMENT_FONDATEUR_V1_10.md (repo perimeter, branche main), D44 dernière décision actée.

Ce qui s'est passé le 28 août 2026 :
- D43 : board ID Monday centralisé dans un node de config unique (workflow PERIMETER_MANAGEMENT_EQUIPE_PRESENTIEL_TT)
- D44 : rappel email automatique créé (workflow PERIMETER_RAPPEL_ROTATION_BOARD) pour la rotation annuelle du 8 octobre — rotation elle-même reste manuelle (choix assumé)

Prochaines étapes prioritaires :
1. Retraiter le jour du 22/09/2026 une fois le tournage réalisé
2. Chantier Outlook (app registration Azure)
```
