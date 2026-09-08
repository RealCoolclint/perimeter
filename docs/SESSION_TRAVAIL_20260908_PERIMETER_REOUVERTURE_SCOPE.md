# Session de travail — 8 septembre 2026
## Perimeter — Réouverture du scope azimuts

*Bloc A stratégique — révision de cadrage produit, aucun code d'application touché*

---

## Chantiers traités

### Réouverture du scope azimuts
Audit de cohérence du fondateur (V1_12) contre le prompt fondateur initial de Perimeter : sur 17 items du prompt d'origine, un seul (time count présentiel/TT) était construit de bout en bout. Le recentrage V1 à 4 azimuts (D10, D13) avait fait perdre l'essentiel de l'ambition initiale — la moitié des idées d'origine étaient reportées sans azimut d'accueil clair (D38), certaines jamais formellement tranchées.

Décision de fond actée : Perimeter n'a de sens que s'il permet un tour complet des sujets préoccupants, pro et perso à égalité — pas une mesure partielle du quotidien.

Scope étendu en deux temps :
- 4 azimuts pro reportés réactivés (Boîte mail, Veille sectorielle, Visibilité & réseaux, Administratif & budget)
- 3 azimuts perso reportés réactivés (Loisirs, Finances perso, Domicile), alimentés par Calendrier + Boîte mail — la règle D11 (pas de saisie manuelle pure côté perso) a été explicitement maintenue, sans assouplissement
- 2 azimuts supplémentaires identifiés en cours de revue (Énergie & charge mentale, Mémoire & connaissance) — le premier réactivé directement, le second laissé en attente faute de source automatique fiable identifiée

Un point de convergence technique a émergé pendant la revue : D31 (points calendrier) et D28 (lecture mail Management) pointent vers un même besoin — un moteur d'interprétation Ollama (Calendrier + Mail → point catégorisé par azimut) exploitable par 8 des 15 azimuts. Ce moteur est identifié comme la brique la plus rentable à construire en priorité, avant une reconstruction azimut par azimut.

Le document fondateur a été versionné en V1_13 et mis à jour par itérations successives via Cursor (3 passes de prompt, chacune suivie d'une relecture des incohérences résiduelles), plutôt qu'en un seul bloc — la relecture croisée à chaque étape a permis de rattraper des renvois cassés (D11, D48, D53) avant qu'ils ne s'accumulent.

---

## Décisions actées

- Perimeter couvre 15 azimuts (10 pro dont 1 en attente, 5 perso), pro et perso à égalité — la distinction "V1 / reportés" est dépréciée, seule la profondeur de construction suit encore une logique d'itération
- La règle D11 (pas de saisie manuelle pure côté perso) est non négociable, y compris pour les azimuts perso ajoutés cette session
- L'azimut "Mémoire & connaissance" reste inactif tant qu'aucune source automatique fiable n'est identifiée — pas d'exception à la règle de saisie manuelle en attendant
- Le moteur d'interprétation Ollama (Calendrier + Mail) est requalifié en brique transverse prioritaire, plutôt qu'une construction répétée azimut par azimut
- Les 4 éléments D38 (checklist projets, candidature Canva, rappel des impératifs, sous-tâches agents) sont requalifiés : deux rattachés à des azimuts existants, deux en capacités transverses du Tour

---

## Livrables produits

| Fichier / Élément | Nature | État |
|-------------------|--------|------|
| `docs/PERIMETER_DOCUMENT_FONDATEUR_V1_13.md` | Doc fondateur | ✅ Pushé sur `main` (commit `81f170a`) |
| Décisions D47 à D56 | Historique de décisions | ✅ Actées et versionnées |

---

## Commandes Terminal produites

```bash
# Copie du fondateur V1_12 vers V1_13 avant édition
cd ~/Documents/GitHub/perimeter
cp docs/PERIMETER_DOCUMENT_FONDATEUR_V1_12.md docs/PERIMETER_DOCUMENT_FONDATEUR_V1_13.md
```

```bash
# Commit et push du fondateur mis à jour
git add docs/PERIMETER_DOCUMENT_FONDATEUR_V1_13.md
git commit -m "Réouverture du scope azimuts (D47-D56) — 8 à 15 azimuts, pro+perso à égalité"
git push
```

---

## Pièges découverts

- Le script de vérification utilisé par Cursor entre deux passes d'édition a produit un faux positif sur une chaîne contenant des guillemets échappés (D55 signalé absent alors qu'il était présent) — symptôme : un grep de contrôle dit "manquant" → vérifier l'échappement des guillemets dans la chaîne de recherche avant de conclure à un échec réel

---

## Prochaines étapes

1. Cadrer techniquement le moteur d'interprétation Ollama transverse (D51) — architecture, prompt, format de sortie du "point catégorisé". Priorité haute : débloque 8 des 15 azimuts d'un coup
2. Trouver une source automatique fiable pour l'azimut "Mémoire & connaissance" (D55) — condition de son activation
3. Définir les seuils de volume (D15) et les constantes de normalisation k (D26) pour les 9 nouveaux azimuts actifs
4. Chantier design du cercle à 15 azimuts (D53/D56) — lisibilité, labels, répartition visuelle
5. Revisiter la section 9 "Roadmap en itérations", devenue inexacte (parle encore de "4 azimuts retenus")
6. Retraiter le jour du 22/09/2026 dans le Suivi Présentiel/TT, une fois le tournage réalisé (en attente depuis la session précédente)

---

*Session 8 septembre 2026 · Perimeter · Mac non précisé*
