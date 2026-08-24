# Session de travail — 24 août 2026
## Perimeter — design du cercle, normalisation, azimut Management d'équipe

*Session de conception — design visuel et arbitrages produit*

---

## Chantiers traités

### Repo GitHub créé
`RealCoolclint/perimeter` créé en privé, cloné sur Mac Maison, premier commit poussé avec les 3 récaps de session existants + le document fondateur v1.2. Perimeter a désormais un filet de sécurité — plus aucun document ne repose uniquement sur la mémoire du projet Claude.

### Direction visuelle du cercle
Trois itérations avant validation. V1 : direction "instrument de navigation nocturne" proposée, écartée par Martin. V2 : direction "papier & encre" retenue — cercle tracé à main levée sur fond crème. V3 : intégration de retours précis après partage d'une référence visuelle NASA (recherche déjà menée pour la Tranquility Suite) — cercle complet en anneau continu (plus d'arcs séparés), labels en retrait reliés par lignes de rappel façon annotation technique, contraste papier/encre renforcé, épaisseur de trait plafonnée. Dernier ajustement : suppression de toute police serif et de toute italique, passage à IBM Plex Sans + IBM Plex Mono uniquement.

### Parcours en 4 séquences
Le besoin de Martin de voir les 4 étapes du parcours Perimeter (ouverture, tracé, compte-rendu, avant/après) a été formalisé en un prototype unique navigable avec stepper cliquable, plutôt que 4 fichiers séparés.

### Échelle de normalisation de l'affichage
Question laissée ouverte depuis le 23 août. Deux prérequis manquants identifiés et comblés en séance : échelle d'urgence (1-5) et d'ancienneté (en semaines) au niveau du point individuel. Choix d'une courbe saturante plutôt qu'un logarithme pur, pour respecter à la fois D14 (charge réelle sans plafond) et la demande de Martin d'un plafond visuel — la courbe sature naturellement sans clamp artificiel.

### Azimut Management d'équipe
Design initial proposé comme purement manuel, corrigé par Martin qui a identifié des sources automatiques disponibles (calendrier, Monday) — puis approfondi une seconde fois quand Martin a relevé l'omission du signal mail. Structure finale hybride actée avec le mail explicitement reporté en V2 (nécessite une lecture Ollama, pas un simple mot-clé, sujet RH-sensible).

---

## Décisions actées

- Le repo `RealCoolclint/perimeter` (privé) est la référence de versioning de Perimeter, séparée des repos Tranquility
- **D24** — Direction visuelle : papier & encre, sans-serif uniquement (IBM Plex Sans + Mono), cercle continu à bord intérieur variable, épaisseur de trait plafonnée, labels en retrait avec lignes de rappel
- **D25** — Parcours en 4 séquences : Ouverture/lancement → Tracé → Compte-rendu + plan d'action → Fin de tâche (avant/après), stepper à 4 points
- **D26** — Normalisation : urgence 1-5, ancienneté en semaines, courbe saturante `charge/(charge+k)` par azimut, charge réelle jamais plafonnée en coulisses
- **D27** — Management d'équipe V1 hybride : automatique (1-to-1 en retard via calendrier, charge Monday en retard/bloquée), manuel (tension, feedback, autre)
- **D28** — Signal mail Management d'équipe reporté en V2, lecture Ollama, scope étroit indépendant de l'azimut Boîte mail

---

## Livrables produits

| Fichier / Élément | Nature | État |
|-------------------|--------|------|
| Repo `RealCoolclint/perimeter` | Repo GitHub privé | ✅ créé et poussé |
| `perimeter_cercle_prototype.html` | Prototype v1 (écarté) | ⚫ |
| `perimeter_cercle_prototype_v2.html` | Prototype v2 (intermédiaire) | ⚫ |
| `perimeter_parcours_prototype_v3.html` | Prototype v3, 4 séquences navigables, typo corrigée | ✅ retenu |
| `PERIMETER_DOCUMENT_FONDATEUR.md` — v1.3 | Document fondateur mis à jour | ✅ |

---

## Pièges découverts

- `PERIMETER_VEILLE_OPENSOURCE.md` mentionné dans les récaps précédents n'a pas été retrouvable via recherche dans les ressources du projet Claude → à reconstituer manuellement si le contenu original n'est pas récupérable ailleurs
- Un azimut classé "manuel par défaut" mérite systématiquement une vérification des sources automatiques déjà connectées ailleurs dans l'écosystème avant validation — deux fois relevé par Martin sur le même azimut (calendrier/Monday d'abord, mail ensuite)

---

## Prochaines étapes

1. Verser `perimeter_parcours_prototype_v3.html` dans un dossier `design/` du repo `perimeter`
2. Reconstituer ou retrouver `PERIMETER_VEILLE_OPENSOURCE.md`
3. Workflow n8n annuel de récupération automatique des dates Parcoursup
4. Première implémentation : schéma Supabase, premiers workflows n8n, premier azimut construit de bout en bout

---

*Session 24 août 2026 · Perimeter · Mac Maison (martinpavloff)*
