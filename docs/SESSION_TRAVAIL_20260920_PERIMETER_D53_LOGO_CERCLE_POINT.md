# Session de travail — Perimeter — D53, charte graphique du cercle à 15 azimuts

*20 septembre 2026 (soir) — suite de la session D77/D78 du même jour*

---

## Contexte de départ

Les 5 priorités ouvertes en début de session (consentement Outlook D74, chantier D69, seuils/k D15/D26, source D55) n'étaient pas actionnables un dimanche soir. Martin redirige explicitement la session : **"On va juste faire une étape sur la charte graphique et le design de l'app."** — chantier D53 (dette de design identifiée depuis le passage de 4 à 15 azimuts).

---

## Déroulé

1. **Master Design & Art Direction Brief adopté (D79)**, remplace D24 intégralement. Palette Obsidian/Ivory/Paper/Slate, typographie Inter (équivalent libre choisi par Martin), primitifs Cercle + Point ("Champ → Signal"), anti-décoration stricte, trois états Veille/Analyse/Alerte.
2. **Prototype réel mis à jour** (`design/perimeter_parcours_prototype_v3.html`) via deux prompts Cursor : nouveaux tokens, Inter partout, `tabular-nums`, suppression des filtres de tremblé. Un oubli (`.center-value`) corrigé par l'auto-relecture de Cursor.
3. **Chantier D53 engagé dans un canvas de design séparé** : deux options comparées à données réelles (Option A "index numéroté au survol" retenue ; Option B "labels rayonnants" écartée, jamais mise à jour depuis).
4. **Premier retour de correction** : le tracé (pics + numéros sur le cercle) jugé "trop informatique" — retiré au profit de points encastrés dans l'épaisseur de l'anneau.
5. **Piste "Arrival"** (Denis Villeneuve) explorée sur demande explicite de Martin — filtre gooey, contour bruité, tentacules asymétriques, encodage strict assoupli sciemment. **Jugée "pas du tout" concluante, abandonnée entièrement (D80).**
6. **Logo Perimeter réel fourni par Martin** (2 variantes : cercle plein/point en réserve ; cercle hairline/point plein, fond grainé) — point de départ effectif retenu. Reconstruction alignée : cercle hairline légèrement irrégulier, points pleins de taille variable (charge), sans contour, sans couleur de distinction par seuil.
7. **Trois ajustements fins validés** : légende en 700, points sans contour, irrégularité minime du cercle.
8. **Correction finale** : points repassés en noir plein uniforme (règle D81 précisée par Martin : "ligne et points toujours en noir, sauf en dark mode où on passe en négatif" — actée comme règle générale de thème sombre, pas limitée à l'état Alerte).
9. **Version validée par Martin** ("bouclé").

---

## Décisions actées cette session

- **D79** — Master Design & Art Direction Brief, remplace D24 intégralement.
- **D80** — Piste organique "Arrival" abandonnée ; retour au primitif Cercle + Point aligné sur le logo réel (taille de point = charge, remplace l'épaisseur d'anneau comme mode d'affichage — la formule D9/D14-D20/D26 ne change pas).
- **D81** — Thème sombre : inversion générale (ligne + points en négatif), pas limitée à l'état Alerte.

Document Fondateur réécrit en **V1.19**.

---

## Ce qui reste à faire (D53)

- Porter la version validée (canvas de design) dans le prototype réel `perimeter_parcours_prototype_v3.html`, via un prompt Cursor dédié.
- Verser le logo Perimeter (2 variantes) dans le repo — emplacement à définir (`design/` ou `assets/`).
- Construire une maquette du thème sombre (D81) — la règle est actée, aucune maquette ne l'illustre encore.
- Décider du sort de l'Option B ("labels rayonnants") — obsolète, à retirer ou marquer clairement comme archivée dans le canvas.

## Non touché cette session (reporté)

- Consentement admin Outlook (D74) — relance envoyée, réponse attendue lundi.
- Chantier D69 (enrichissement lieu Outlook/Monday) — nécessite un jour de semaine avec vraies données.
- Seuils (D15) et constantes k (D26) pour les 9 nouveaux azimuts.
- Source automatique fiable pour "Mémoire & connaissance" (D55).

---

## Prompt de continuation

```
Bonjour JARVIS ! On reprend Perimeter — suite de la session du 20/09 (soir), chantier design D53.

Ce qui s'est passé : Master Brief adopté (D79, remplace D24 intégralement) et appliqué
au prototype réel via Cursor. Chantier D53 (cercle à 15 azimuts) mené dans un canvas de
design séparé — une piste organique inspirée d'Arrival a été testée puis entièrement
abandonnée (D80, jugée "pas du tout" concluante). Retour au primitif Cercle + Point
directement aligné sur le logo Perimeter réel (fourni par Martin en session) : cercle
hairline légèrement irrégulier, points pleins dont la taille encode la charge, toujours
noirs (D81 : inversion générale en thème sombre, pas limitée à l'état Alerte). Version
validée par Martin ("bouclé"). Fondateur réécrit en V1.19.

Document de référence : PERIMETER_DOCUMENT_FONDATEUR_V1_19.md (repo RealCoolclint/perimeter,
branche main).

Prochaines étapes prioritaires, dans l'ordre logique/constructif/sécurisé :
1. Porter la version validée du cercle (canvas de design) dans le prototype réel
   design/perimeter_parcours_prototype_v3.html, via un prompt Cursor dédié.
2. Verser le logo Perimeter (2 variantes) dans le repo (design/ ou assets/ — à trancher).
3. Vérifier si Florian/Wagner ont validé le consentement admin Outlook (D74).
4. Si débloqué : reconnecter le credential Outlook, retester isolé avant de construire.
5. Chantier dédié lieu Outlook/Monday (D69), un jour de semaine avec de vraies données.
6. Seuils (D15) et constantes k (D26) pour les 9 nouveaux azimuts.
7. Source fiable pour "Mémoire & connaissance" (D55).

Bonne session !
```
