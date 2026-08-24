# Session de travail — 24 août 2026
## Perimeter — formule de charge (finalisation), hébergement, modèle IA, LinkedIn

*Session hybride — arbitrages techniques et produit*

---

## Chantiers traités

### Formule de charge — finalisation
La formule posée le 23 août (D9) a été entièrement chiffrée : bonus de seuil progressif avec seuils par azimut, et poids contextuel décomposé en deux composantes multipliées (journée × période), chacune avec ses signaux et ses valeurs.

### Hébergement définitif
Vérification d'actualité sur Oracle Cloud Free Tier : réduction silencieuse des quotas Always Free (4 OCPU/24 Go → 2 OCPU/12 Go, effective depuis juin 2026, suppression des ressources excédentaires après le 18 août 2026). Décision de découpler les deux briques cloud pour limiter le risque sur la donnée sensible.

### Modèle IA
RAM du Mac Maison confirmée (16 Go). Recherche des modèles Ollama adaptés à cette capacité, confirmation du choix Mistral déjà pressenti, en version 7B.

### Blocage LinkedIn
Proposition détaillée reçue de ChatGPT (RADAR + CAPTURE + INTELLIGENCE). Analysée contre le risque de dérive de périmètre déjà identifié le 23 août (D13) — triage effectué pour ne garder que la partie immédiatement pertinente et reporter le reste.

---

## Décisions actées

- **D14** — Bonus de seuil progressif : `charge brute × 10% × (points ouverts − seuil)`, sans plafond.
- **D15** — Seuils de volume par azimut : Calendrier & temps (3), Pilotage de projets/Monday (6), Carrière (2), Management d'équipe (2).
- **D16** — Poids contextuel, composante journée : +0.2 si journée dense en réunions (>4h), +0.3 si journée de tournage/terrain.
- **D17** — Poids contextuel, composante période : détection combinée (dates fixes connues + calcul dynamique depuis les deadlines Monday) ; Parcoursup récupéré automatiquement chaque année (recherche/calendrier officiel).
- **D18** — Majorations dates fixes : Rentrée sept +0.3, Salons oct-mars +0.1, Parcoursup +0.3, Bac/Brevet +0.3 — cumulables si chevauchement de périodes.
- **D19** — Majoration dynamique : +0.2 si plus de 3 échéances Monday dans les 7 jours à venir.
- **D20** — Formule complète du poids contextuel actée : `Poids journée × Poids période`.
- **D21** — Hébergement définitif : n8n auto-hébergé sur Oracle Cloud Free Tier ; Supabase en Cloud managé (pas self-hosted) pour la mémoire/stockage ; Ollama reste en local, inchangé.
- **D22** — Modèle IA définitif : Mistral 7B, confirmé pour le Mac Maison (16 Go).
- **D23** — LinkedIn : la brique CAPTURE (bookmarklet "Envoyer à Perimeter", résumé/catégorisation manuelle) est retenue pour l'activation de l'azimut Visibilité & réseaux (V1 ou V2) ; les briques RADAR (veille automatisée multi-sources) et INTELLIGENCE (croisement de signaux, détection de tendances) sont reportées en V3, en cohérence avec le chantier "capital professionnel" déjà prévu.

---

## Livrables produits

| Fichier / Élément | Nature | État |
|-------------------|--------|------|
| PERIMETER_DOCUMENT_FONDATEUR.md — v1.2 | Document fondateur mis à jour | ✅ |
| SESSION_TRAVAIL_20260824_PERIMETER_HEBERGEMENT_MODELE_LINKEDIN.md | Récap de session | ✅ |

---

## Prochaines étapes

1. Design visuel précis du cercle (skill frontend-design à mobiliser)
2. Échelle de normalisation pour l'affichage visuel (probablement logarithmique)
3. Détail de la saisie manuelle pour Management d'équipe (format, fréquence)
4. Mise en place concrète du workflow n8n annuel de récupération automatique des dates Parcoursup
5. Passage de la conception à la première implémentation — premier azimut à construire, schéma Supabase, premiers workflows n8n

---

*Session 24 août 2026 · Perimeter · Mac non identifié pour cette session (session de conception, pas de code exécuté)*
