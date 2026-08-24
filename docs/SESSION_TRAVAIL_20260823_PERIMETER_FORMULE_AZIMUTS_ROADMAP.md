# Session de travail — Perimeter — 23 août 2026

*Formule de charge, azimuts V1, mécanique du Tour, roadmap V1/V2/V3*

---

## Contexte de départ

Reprise de session sur Perimeter après la session fondatrice du 22 août 2026 (architecture technique, concept du cercle, `PERIMETER_DOCUMENT_FONDATEUR.md` v1.0). Quatre chantiers restaient ouverts : formule de charge, hébergement, azimuts V1 vs reportés, faisabilité globale.

---

## Décisions actées cette session

**D8 — Référence de concept CleanMyMac**
Le mécanisme de Perimeter s'inspire du modèle CleanMyMac : indicateurs continus (épaisseur du cercle) + protocole de scan à la demande (le Tour) + actions proposées, jamais automatiques.

**D9 — Formule de calcul de la charge par azimut**
`(charge brute des points + bonus de seuil) × poids contextuel`
- Charge brute = somme des scores `urgence × ancienneté` de chaque point
- Bonus de seuil = déclenché si le volume de points dépasse un seuil propre à l'azimut
- Poids contextuel = multiplicateur automatique (calendrier du jour + période), sans réglage manuel de Martin

**D10 — Azimuts V1**
Critère de sélection : la douleur ressentie prime sur la facilité technique.
- Retenus V1 : Calendrier & temps, Pilotage de projets (Monday), Carrière & opportunités, Management d'équipe
- Reportés : Boîte mail, Veille sectorielle, Visibilité & réseaux, Administratif & budget, Énergie & charge mentale, Mémoire & connaissance

**D11 — Élargissement du périmètre pro + perso**
Perimeter couvre toute la vie de Martin, pas seulement le pro. Ajout de Santé et Famille & proches (reportés, source auto disponible via Calendrier). Loisirs, Finances perso et Domicile explorés mais non retenus, faute de source automatique fiable (règle : pas de saisie manuelle pure côté perso).

**D12 — Mécanique du Tour en 3 phases**
1. Tour de check — collecte du delta depuis le dernier passage
2. Constat de la charge — tous les azimuts passés en revue un par un, sans résoudre, pour construire un plan d'action priorisé
3. Tour de résolution — exécution du plan, propositions d'action, validation de Martin

**D13 — Roadmap en itérations V1 / V2 / V3**
Suite à un retour détaillé de ChatGPT sur le module carrière (comparaison avec ApplyPass), triage effectué pour éviter la dérive de périmètre :
- **V1** : le socle déjà acté (cercle, 4 azimuts, formule, Tour en 3 phases, carrière avec sources simples)
- **V2** : distinction Problèmes/Signaux/Actions, dimension "Opportunité" séparée de la "Charge" pour la Carrière, mémoire des refus/préférences, arbitrage sur l'ordre de construction (moteur du Tour avant finition visuelle du cercle)
- **V3** : capital professionnel (graphe relationnel), profil vectoriel complet (embeddings CV/trajectoires), abstraction multi-LLM

---

## Point de veille noté (pas une décision, une vigilance)

n8n fonctionne sous Sustainable Use License — sans impact pour un usage strictement personnel, mais à réexaminer si Perimeter devait un jour être distribué à d'autres personnes.

---

## Document mis à jour

`PERIMETER_DOCUMENT_FONDATEUR.md` — passé de v1.0 à **v1.1**, mis à jour en direct à chaque décision (pas de rattrapage en fin de session). Structure enrichie de deux nouvelles sections : Formule de calcul (section 5) et Roadmap V1/V2/V3 (section 11). Doublons nettoyés en section "reste à trancher".

---

## Ce qui reste à trancher (reporté aux prochaines sessions)

- Seuils précis du bonus de volume par azimut
- Règles exactes du poids contextuel (signaux calendrier/période)
- Échelle de normalisation pour l'affichage visuel (probablement logarithmique)
- Design visuel précis du cercle (skill frontend-design à mobiliser)
- Choix d'hébergement définitif (Oracle Cloud Free Tier ou alternative)
- Modèle IA définitif selon la RAM du Mac principal utilisé
- Solution retenue pour le blocage LinkedIn (lecture manuelle assistée)
- Détail de la saisie manuelle pour Management d'équipe (format, fréquence)

---

## Prompt de continuation

```
On reprend le travail sur Perimeter — mon outil personnel qui parcourt le
périmètre de mes préoccupations quotidiennes et propose des solutions
intelligentes pour alléger ma charge mentale.

Ce qui s'est passé lors de la dernière session (23 août 2026) :
- Formule de calcul de la charge actée (D9) : (charge brute + bonus de
  seuil) × poids contextuel automatique
- Azimuts V1 tranchés (D10) : Calendrier & temps, Pilotage de projets,
  Carrière & opportunités, Management d'équipe
- Périmètre élargi pro + perso (D11) : ajout Santé et Famille & proches
- Mécanique du Tour précisée en 3 phases (D12) : check → constat de la
  charge (tous les azimuts en revue, plan d'action priorisé) → résolution
- Roadmap en itérations actée (D13) : V1 (socle) → V2 (Problèmes/Signaux/
  Actions, dimension Opportunité pour Carrière, mémoire des refus) → V3
  (capital professionnel, profil vectoriel, multi-LLM)

Document de référence :
PERIMETER_DOCUMENT_FONDATEUR.md (v1.1, 23 août 2026)

Prochaines étapes prioritaires :
1. Seuils du bonus de volume par azimut + règles du poids contextuel
2. Confirmer l'hébergement (Oracle Cloud Free Tier ou alternative)
3. Modèle IA définitif selon la RAM du Mac principal
4. Solution pour le blocage LinkedIn (lecture manuelle assistée ?)

Bonne session !
```

---

*Récapitulatif généré en fin de session — reste en ressources projet Claude, jamais poussé sur GitHub.*
