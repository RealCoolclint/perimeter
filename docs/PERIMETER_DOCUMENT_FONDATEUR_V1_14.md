# PERIMETER — Document Fondateur

*Projet personnel de Martin Pavloff — hors Tranquility Suite*
*Version 1.14 — 9 septembre 2026*

---

## 1. Le concept fondateur

Perimeter part d'une image simple et puissante :

> **Un cercle. Martin au centre, le trait fin.**
> Chaque azimut du cercle représente une catégorie de préoccupation personnelle ou professionnelle. Sur chaque azimut se déposent des points — des problèmes concrets, non résolus.
>
> Plus ces points sont nombreux et anciens, plus le trait du cercle **s'épaissit et se rapproche du centre** : c'est la représentation visuelle de la charge, de la pression ressentie.
>
> Perimeter **parcourt le cercle**, azimut par azimut, adresse ce qui peut l'être, propose des actions pour le reste. Chaque tour qui résout des points **amincit le trait** — et donc allège la charge perçue.

Ce principe unique organise toutes les fonctionnalités de l'app : elles existent pour réduire l'épaisseur du cercle, pas pour empiler de l'information.

**D8 — Référence de concept.** Le mécanisme de Perimeter s'inspire du modèle CleanMyMac : indicateurs continus (épaisseur du cercle) + protocole de scan à la demande (le Tour) + actions proposées, jamais automatiques.

---

## 2. Vision produit en une phrase

Perimeter fait le tour des préoccupations quotidiennes et générales de Martin, et propose des solutions adaptées et intelligentes — dans le but constant d'alléger la charge mentale ressentie.

---

## 3. Les azimuts

**Périmètre du projet (D11, réouvert D47) : pro + perso, à égalité.** Perimeter couvre toute la vie de Martin — le tour n'a de sens que s'il est complet. Règle de sélection transverse, maintenue sans assouplissement (D11, reconfirmée D49) : pas de saisie manuelle pure côté perso — un azimut n'est retenu que s'il dispose d'une source automatique fiable.

**Scope total acté (D50) : 15 azimuts (D56).** La distinction "azimuts V1 / azimuts reportés" est dépréciée — tous les azimuts existent dans le cercle. La distinction par itération (V1/V2/V3, D13) reste valable uniquement pour la profondeur de construction de chaque azimut, pas pour décider de son existence.

### Azimuts pro (10, dont 1 en attente)

- **Calendrier & temps** — charge de la journée, présentiel/télétravail (poids journée implémenté, D16 ; détection des points désormais opérationnelle via le moteur Ollama transverse, D31/D51/D57-D68)
- **Pilotage de projets** — Monday, chantiers en retard, statuts. Sous-fonctionnalité : checklist des éléments nécessaires aux projets du jour/semaine (D52)
- **Carrière & opportunités** — offres d'emploi, candidatures. Sous-fonctionnalité : proposition de candidature + lettre de motivation (template Canva) (D52)
- **Management d'équipe** — 1-to-1, charge des collaborateurs (structure hybride D27, D28)
- **Boîte mail** *(réactivé D48)* — tri, relances, résumés, deadlines cachées, proposition de réponses aux mails éligibles
- **Veille sectorielle** *(réactivé D48)* — presse dédiée (vidéo / médias digitaux / IA) + veille technologique sur ces mêmes secteurs
- **Visibilité & réseaux** *(réactivé D48)* — audience Insta/TikTok/YouTube, LinkedIn. Brique CAPTURE (bookmarklet manuel) en V1/V2, RADAR/INTELLIGENCE (veille automatisée) en V3 (D23, inchangé)
- **Administratif & budget** *(réactivé D48)* — échéances, notes de frais
- **Énergie & charge mentale** *(réactivé D54)* — surcharge de réunions, pauses. Source auto : Calendrier (recoupe la majoration "+0.2 si journée dense en réunions", D16 — à enrichir au-delà des seules réunions)
- **Mémoire & connaissance** *(rouvert en principe, D55 — azimut en attente)* — journal de décisions, base de contacts. Pas encore actif : aucune source automatique fiable identifiée à ce jour. Contrainte D11 maintenue sans exception — recherche d'une vraie source auto à mener avant activation, pas de saisie manuelle en attendant

### Azimuts perso (5)

- **Santé** — source auto : Calendrier (D11)
- **Famille & proches** — source auto : Calendrier (D11)
- **Loisirs** *(réactivé D49)* — source auto : Calendrier + Boîte mail
- **Finances perso** *(réactivé D49)* — source auto : Boîte mail (factures, relances, échéances)
- **Domicile** *(réactivé D49)* — source auto : Calendrier + Boîte mail (RDV artisans, livraisons, travaux)

### Capacités transverses (D52) — pas des azimuts, des couches du Tour

- **Rappel des impératifs** — capacité de la phase résolution du Tour (D12), pas liée à un azimut unique
- **Sous-tâches via agents** — capacité transverse du Tour, dépendante d'une orchestration multi-agents non construite, reste en V3

---

## 4. Le principe de fonctionnement — Le Tour

- **Déclenchement** : à chaque ouverture de session, sur n'importe quel Mac (Maison / Bureau / Studio) — pas de veille permanente en tâche de fond, pas de Mac à laisser allumé.
- **Mémoire du tour** : chaque passage se souvient du précédent (stocké dans Supabase) — quand il a eu lieu, ce qui a été montré, ce qui est resté sans réponse.
- **Profondeur adaptative** : le 1er tour de la journée regarde loin (nuit + journée à venir). Les tours suivants ne regardent que le delta depuis le dernier passage, et vérifient en priorité si les propositions précédentes ont été traitées.

### Mécanique en 3 phases (D12)

1. **Tour de check** — collecte du delta depuis le dernier passage.
2. **Constat de la charge** — tous les azimuts passés en revue un par un, sans résoudre, pour construire un plan d'action priorisé.
3. **Tour de résolution** — exécution du plan, propositions d'action, validation de Martin.

**Objectif de chaque tour** : faire baisser la charge (épaisseur du cercle) en résolvant ou en proposant une action sur chaque point identifié.

---

## 5. Formule de calcul de la charge

### Formule générale (D9)

```
Charge par azimut = (charge brute des points + bonus de seuil) × poids contextuel
```

- **Charge brute** = somme des scores `urgence × ancienneté` de chaque point de l'azimut
- **Bonus de seuil** = déclenché si le volume de points dépasse un seuil propre à l'azimut
- **Poids contextuel** = multiplicateur automatique (calendrier du jour + période), sans réglage manuel de Martin

### Bonus de seuil — progressif, sans plafond (D14, D15)

```
Bonus de seuil = charge brute × 10% × (points ouverts − seuil), si points ouverts > seuil
                = 0, sinon
```

Volontairement sans plafond : l'effet de débordement doit rester visible même en cas de surcharge extrême sur un azimut.

**Seuils de volume par azimut (D15) :**

| Azimut | Seuil |
|---|---|
| Calendrier & temps | 3 points ouverts simultanés |
| Pilotage de projets (Monday) | 6 points ouverts |
| Carrière & opportunités | 2 points ouverts |
| Management d'équipe | 2 collaborateurs en attente |

### Poids contextuel — deux composantes multipliées (D16 à D20)

```
Poids journée   = 1.0 + majoration réunions + majoration tournage/terrain
Poids période   = 1.0 + majoration dates fixes + majoration dynamique (deadlines Monday)

Poids contextuel = Poids journée × Poids période
```

**Composante journée (D16)** — signaux calendrier du jour :

| Signal détecté | Majoration |
|---|---|
| Journée dense en réunions (>4h cumulées) | +0.2 |
| Journée de tournage / terrain (déplacement) | +0.3 |
| Journée calme / bureau | 0 (neutre) |

**Composante période — détection combinée (D17)** : dates fixes connues + calcul dynamique depuis la densité des deadlines Monday. Cumulables si deux périodes se chevauchent (ex: rentrée + salons en septembre) — volontaire, ça reflète la vraie surcharge quand plusieurs pics se superposent.

**Majorations "dates fixes" (D18) :**

| Période | Fenêtre | Majoration |
|---|---|---|
| Rentrée de septembre | 1–30 sept | +0.3 |
| Salons | 1er oct – 31 mars | +0.1 (fond, longue durée) |
| Parcoursup (vœux + résultats) | Récupérée automatiquement chaque année (recherche/calendrier officiel — workflow n8n annuel à prévoir) | +0.3 |
| BAC & Brevet (résultats) | Fin juin / début juillet | +0.3 |

**Majoration "dynamique" (D19)** : +0.2 si plus de 3 échéances Monday dans les 7 jours à venir.

---

## 6. Interface

**Décision actée : le cercle EST l'écran d'accueil.** Pas un dashboard classique en premier plan — un visuel circulaire central qui représente la charge en temps réel, azimut par azimut. Le détail (brief textuel, propositions) s'ouvre au clic sur un point du cercle.

### Direction visuelle (D24) — papier & encre

- **Palette** : papier crème `#F1ECDF`, encre quasi noire `#1E1B15`, encre pâle `#A79E8C` (résolu/discret), hairline `#C7BDA6`, rouge de rubrication `#A13A22` (accent rare, réservé au dépassement de seuil) — contraste fort, volontairement éloigné du dark theme NASA/Apollo de la Tranquility Suite (identité distincte assumée)
- **Typographie** : sans-serif uniquement, aucune italique — **IBM Plex Sans** pour tous les textes, **IBM Plex Mono** pour les données chiffrées (points, pourcentages, dates courtes)
- **Le cercle** : un anneau continu (pas des arcs séparés), tracé à main levée (léger tremblé via déformation SVG). Le bord extérieur reste stable ; le bord intérieur se rapproche du centre selon la charge, avec transition fluide entre azimuts — pas de cassures nettes
- **Épaisseur plafonnée** : le trait varie entre une épaisseur minimale (calme) et une épaisseur maximale fixe — jamais de débordement visuel, quelle que soit la charge réelle sous-jacente (voir section 5bis, normalisation)
- **Labels en retrait** : les noms d'azimuts ne touchent jamais le cercle — reliés par une fine ligne de rappel (point sur le tracé → coude → texte), inspiré des annotations techniques (recherche NASA de la Tranquility Suite)
- **Fanion "seuil"** : petit marqueur rouge de rubrication sur l'azimut qui dépasse son seuil, écho réduit du bandeau "CAUTION" exploré pour Tranquility

### Parcours en 4 séquences (D25)

Un stepper à 4 points matérialise l'avancement :

1. **Ouverture / lancement** — cercle neutre (charge non affichée), bouton "Lancer le tour"
2. **Tracé avec charge réelle** — le cercle tel que décrit ci-dessus, azimut par azimut
3. **Compte-rendu + plan d'action** — le cercle se réduit en médaillon, liste d'actions triée par charge décroissante, barre de progression globale
4. **Fin de tâche — avant/après** — deux tracés (avant estompé, après net) avec le delta chiffré par azimut, preuve visuelle que le tour a allégé la charge

Prototype de référence : `perimeter_parcours_prototype_v3.html` (à verser dans `design/` du repo).

### 5bis. Normalisation de l'affichage (D26)

- **Unités atomiques d'un point** : urgence (échelle 1 à 5), ancienneté (en semaines depuis l'ouverture)
- **Séparation stricte** : la charge brute réelle n'est jamais plafonnée (cohérent avec D14) — seul l'affichage sature. La valeur stockée dans Supabase sert de référence pour les comparaisons avant/après (séquence 4) et la détection de seuil, jamais la version affichée
- **Courbe de normalisation** : `affichage = charge / (charge + k)` — jamais de plafond artificiel, l'asymptote fait le travail. `k` par azimut dérivé du seuil déjà acté (D15) avec urgence médiane (3) et ancienneté médiane (2 semaines) comme référence : Calendrier & temps k=18, Pilotage de projets k=36, Carrière & opportunités k=12, Management d'équipe k=12
- **Charge totale centrale** : moyenne des 4 fractions normalisées × 100 (lecture "48" = "48% de charge globale")

---

## 7. Architecture technique validée

| Couche | Choix | Pourquoi |
|---|---|---|
| **Orchestration (atelier)** | n8n auto-hébergé sur Oracle Cloud Free Tier (2 OCPU / 12 Go — allocation réduite depuis juin 2026) | Gratuit, n8n est léger et tient confortablement dans les nouvelles limites. Risque de coupure existant mais faible impact (rejouer un tour manuellement si besoin) — **D21** |
| **Intelligence** | Ollama en local, sur le Mac utilisé au moment du tour — **Ministral 3 8B confirmé (D58, remplace Mistral 7B / D22)**, testé pour le Mac Maison (16 Go) | Zéro coût récurrent, données sensibles (mails) qui ne sortent pas de la machine ; 8B tient confortablement dans 16 Go avec marge pour le reste du système ; sortie JSON structurée native, mieux adaptée au moteur d'interprétation (D51) |
| **Mémoire / stockage (archives)** | Supabase Cloud managé — pas de self-hosting (Postgres + pgvector inclus, free tier ~500 Mo) — **D21** | Plus fiable que du self-hosted sur Oracle pour la donnée la plus sensible (mémoire des tours) ; zéro serveur à administrer, mise en route plus rapide |
| **Identification** | Coffre-fort chiffré n8n pour les clés API des services externes ; login simple pour Martin | Pas de clé en clair, cohérent avec les pratiques déjà validées sur RENDEZVOUS |
| **Portabilité** | App installée localement sur chaque Mac, connectée en partie au cloud pour tout ce qui n'a pas besoin d'être local | Aucun Mac à privilégier ni à laisser allumé ; synchronisation à l'ouverture de session |

**Point de vigilance Oracle (mis à jour août 2026) :** Oracle a réduit sans annonce publique l'allocation Always Free du compute ARM de 4 OCPU/24 Go à 2 OCPU/12 Go (effectif depuis le 15 juin 2026), avec suppression des ressources dépassant la nouvelle limite après le 18 août 2026. Le tier reste utilisable pour n8n (léger), mais n'est plus considéré comme un socle 100% stable — d'où la décision de sortir Supabase du même risque en le mettant en Cloud managé plutôt qu'auto-hébergé sur la même instance.

**Point de veille n8n (pas une décision, une vigilance) :** n8n fonctionne sous Sustainable Use License — sans impact pour un usage strictement personnel, mais à réexaminer si Perimeter devait un jour être distribué à d'autres personnes.

**Piège réseau documenté (D65) :** depuis l'intérieur du conteneur Docker qui fait tourner n8n, `localhost` pointe vers le conteneur lui-même, jamais vers le Mac hôte. Sur Docker Desktop macOS, `http://host.docker.internal:11434` résout ce problème nativement, sans configuration additionnelle — c'est l'adresse à utiliser pour tout appel n8n → Ollama.

---

## 8. Contraintes réelles identifiées par source (vérifiées août 2026)

**Faciles, gratuites, officielles :**
- Gmail, Google Calendar, YouTube Data/Analytics : API officielles gratuites
- Monday : déjà intégré côté Tranquility, réutilisable
- Instagram Graph API : gratuite, nécessite un compte Pro relié à une page Facebook

**Faisables avec un peu de travail :**
- Presse : pas de scan automatique magique — flux RSS ciblés, 100% gratuits
- France Travail (ex Pôle Emploi) : API officielle et gratuite, 300 000+ offres structurées en temps réel

**Point fort inattendu :**
- Publier sur LinkedIn en son propre nom est gratuit et sans validation partenaire (scope `w_member_social`, self-service)

**Vrai blocage :**
- Lire automatiquement le fil LinkedIn (posts d'autres personnes) : aucune API officielle viable. Solution : lecture manuelle ou semi-automatique, pas une vraie veille automatisée.
- TikTok : API business existante mais limitée aux statistiques d'audience, pas de veille de contenu.

---

## 9. Roadmap en itérations (D13)

Suite à un retour détaillé de ChatGPT sur le module carrière (comparaison avec ApplyPass), triage effectué pour éviter la dérive de périmètre :

- **V1 — Le socle** : le cercle, les 4 azimuts retenus, la formule de charge complète, le Tour en 3 phases, la Carrière avec ses sources simples.
- **V2** : distinction Problèmes / Signaux / Actions, dimension "Opportunité" séparée de la "Charge" pour la Carrière, mémoire des refus/préférences, arbitrage sur l'ordre de construction (moteur du Tour avant finition visuelle du cercle).
- **V3** : capital professionnel (graphe relationnel), profil vectoriel complet (embeddings CV/trajectoires), abstraction multi-LLM.

---

## 10. Historique des décisions actées

- **D1** — Nom provisoire retenu : Perimeter
- **D2** — Architecture hybride : collecte + mémoire dans le cloud (à la demande), intelligence en local
- **D3** — Base de données : Supabase (Postgres + pgvector)
- **D4** — Orchestration : n8n comme colonne vertébrale
- **D5** — Déclenchement : à chaque ouverture de session, tour adaptatif selon la mémoire du tour précédent
- **D6** — Concept fondateur : le cercle, la charge, les azimuts
- **D7** — Interface : le cercle est l'écran d'accueil central, visuel
- **D8** — Référence de concept : modèle CleanMyMac (indicateurs continus + scan à la demande + actions proposées)
- **D9** — Formule de calcul de la charge : (charge brute + bonus de seuil) × poids contextuel automatique
- **D10** — Azimuts V1 tranchés : Calendrier & temps, Pilotage de projets, Carrière & opportunités, Management d'équipe
- **D11** — Périmètre élargi pro + perso : ajout Santé et Famille & proches (reportés) ; Loisirs/Finances/Domicile exclus faute de source automatique (statut Loisirs/Finances/Domicile révisé par D49)
- **D12** — Mécanique du Tour précisée en 3 phases : check → constat de la charge → résolution
- **D13** — Roadmap en itérations actée : V1 (socle) → V2 (Problèmes/Signaux/Actions, Opportunité, mémoire des refus) → V3 (capital professionnel, profil vectoriel, multi-LLM)
- **D14** — Bonus de seuil progressif : +10% de la charge brute par point au-delà du seuil, sans plafond
- **D15** — Seuils de volume par azimut : Calendrier & temps (3), Monday (6), Carrière (2), Management d'équipe (2)
- **D16** — Poids contextuel, composante journée : +0.2 si journée dense en réunions, +0.3 si journée de tournage/terrain
- **D17** — Poids contextuel, composante période : détection combinée (dates fixes + calcul dynamique deadlines Monday) ; Parcoursup récupéré automatiquement chaque année
- **D18** — Majorations dates fixes actées : Rentrée sept +0.3, Salons oct-mars +0.1, Parcoursup +0.3, Bac/Brevet +0.3, cumulables si chevauchement
- **D19** — Majoration dynamique : +0.2 si plus de 3 échéances Monday dans les 7 jours à venir
- **D20** — Formule complète du poids contextuel actée : `Poids journée × Poids période`
- **D21** — Hébergement définitif : n8n sur Oracle Cloud Free Tier ; Supabase en Cloud managé (pas self-hosted) pour la mémoire/stockage ; Ollama reste en local
- **D22** — Modèle IA définitif : Mistral 7B, confirmé pour le Mac Maison (16 Go)
- **D23** — LinkedIn : la brique CAPTURE (bookmarklet "Envoyer à Perimeter", résumé/catégorisation manuelle) est retenue pour l'activation de l'azimut Visibilité & réseaux (V1 ou V2) ; les briques RADAR (veille automatisée multi-sources) et INTELLIGENCE (croisement de signaux, détection de tendances) sont reportées en V3, en cohérence avec le chantier "capital professionnel" déjà prévu.
- **D24** — Direction visuelle actée : papier & encre, sans-serif uniquement (IBM Plex Sans + Mono), cercle continu à bord intérieur variable, épaisseur de trait plafonnée, labels en retrait reliés par lignes de rappel, identité distincte du dark theme NASA/Apollo de la Tranquility Suite
- **D25** — Parcours en 4 séquences acté : Ouverture/lancement → Tracé → Compte-rendu + plan d'action hiérarchisé → Fin de tâche (avant/après), matérialisé par un stepper à 4 points
- **D26** — Échelle de normalisation actée : urgence 1-5, ancienneté en semaines, courbe saturante `charge/(charge+k)` par azimut (k dérivé des seuils D15), charge réelle jamais plafonnée, seul l'affichage sature ; charge totale centrale = moyenne des fractions normalisées × 100
- **D27** — Azimut Management d'équipe, structure V1 hybride : automatique (1-to-1 en retard via motif calendrier `Point Hebdo [Nom] x Martin`, seuil 10 jours ; charge Monday en retard/bloquée par collaborateur), manuel (tension à adresser, feedback en attente, autre)
- **D28** — Signal mail sur Management d'équipe reporté en V2, lecture Ollama du contenu (pas un mot-clé), scope étroit à cet azimut, indépendant de la construction complète de l'azimut Boîte mail (toujours reporté)
- **D29** — Repo `perimeter` passé en public pour garantir l'accès direct de JARVIS (lecture seule via clone Git standard, sans authentification). Condition de réversibilité actée : dès que Perimeter contient de la donnée réelle sensible (tensions d'équipe nominatives, candidatures en cours), la question du retour en privé doit être reposée.
- **D30** — n8n : développement et validation en local (Docker) d'abord, migration vers Oracle Cloud Free Tier (D21) une fois la logique métier stable — évite de mélanger debug infrastructure et debug logique.
- **D31** — Azimut Calendrier & temps : la notion de "point" nécessite une interprétation intelligente du calendrier (Ollama), pas une convention manuelle (préfixe de titre, Google Tasks, calendrier dédié). Chantier dédié à part, dissocié du calcul du poids journée (D16) qui lui est déjà implémenté et fonctionnel.
- **D32** — Détection "journée de tournage/terrain" (D16) : basée sur le champ Lieu des événements calendrier, comparé à une liste de lieux "bureau" connus, affinée avec l'usage réel.
- **D33** — Nouvel azimut/sous-fonctionnalité "Suivi Présentiel/TT" (Management d'équipe) : tableau vivant par personne, alimenté depuis Monday.com (board `5033664702`, rotation annuelle au 8 octobre — archives conservées). Deux types d'événements suivis : présentiel exceptionnel (tournage planifié un jour TT théorique) et TT exceptionnel (item "TT [Prénom]" sur une période présentielle). Aucun calcul de compensation ni de solde correctif — collecte factuelle et datée à visée d'argumentation (cf. note de service RH du 24/07/2026). Rythme fixe par personne à enregistrer en config datée (a déjà changé une fois, le 13/10/2025).
- **D34** — Rythme fixe D33 confirmé et datée : un seul rythme, identique pour toute l'équipe suivie (Thomas Clicteur, Antoine Paley, Charlyne Féneant, Lisa Mazal, Maëlle Das Neves) — TT lundi/mardi/vendredi, présentiel mercredi/jeudi, en vigueur depuis le **13/10/2025**. Règle de désambiguïsation actée : "Antoine" seul dans un item Monday désigne toujours Antoine Paley (jamais Antoine Vassas, hors équipe directe). Périodes "école" des alternantes (Charlyne, Lisa, Maëlle) traitées comme hors-jeu — aucune détection TT/présentiel appliquée ces jours-là, pas de logique de priorité construite pour ce cas rare.
- **D35** — Source de détection TT/RTT sur le board `5033664702` : colonnes `Période - Start` / `Période - End` (109 des 114 lignes `Statut Prod = Absence` renseignées), pas `Date de tournage`. Règle de classification : le mot "TT" doit être détecté comme token isolé, jamais comme sous-chaîne de "RTT" (piège identifié : "RTT" contient "TT"). Le filtre `Statut Prod = Absence` + `Période` non vide exclut naturellement les lignes mal taguées (vraies productions classées par erreur en Absence).
- **D36** — Rythme antérieur au 13/10/2025 confirmé : présentiel mardi/mercredi (donc TT lundi/jeudi/vendredi), en vigueur depuis le **01/09/2024**. Le Code node de classification gère désormais deux périodes de rythme successives (la plus récente prioritaire), avant le 01/09/2024 aucun rythme n'est appliqué (donnée hors scope).
- **D37** — Détection présentiel exceptionnel affinée après vérification croisée avec l'export Excel du board (recalcul indépendant, comparé ligne à ligne à la sortie n8n). Trois ajustements actés : (1) filtre sur la colonne `Pôles` — exclusion des tournages où la Cellule Vidéo n'intervient pas (StudyAdvisor, Solo Redac, Pôle ?) ; (2) `Responsable Backup` ajouté comme repli quand `Resp. Tournage` est vide, la personne de backup étant de facto sur le tournage ; (3) quand aucune personne du roster n'est identifiée, le jour est attribué par défaut à **Martin Pavloff** plutôt qu'ignoré, mais marqué comme non confirmé via une colonne booléenne dédiée `confirme` sur la table `presentiel_tt_evenements` — pour distinguer données vérifiées et estimations. Les estimations (`confirme = false`) ont vocation à être affinées ultérieurement par croisement avec mail, Teams et calendrier.
- **D40** — Correction d'une erreur de comptage dans le récap du 25 août 2026 : D37 annonçait 15 lignes confirmées / 41 non confirmées, la réalité en base (vérifiée par requête de contrôle le 27 août) était 13 confirmées / 43 non confirmées. Total de 56 lignes `presentiel_exceptionnel` inchangé — erreur de répartition dans le document, pas de corruption de données.
- **D41** — Cadrage de l'affinage des 43 jours non confirmés, quatre décisions actées après vérification manuelle ligne par ligne par Martin (mail/Teams/calendrier) : (1) les jours sans présence physique réelle ("solo rédac", montage sur banque d'images) sont retirés de la table, ils ne constituent pas un vrai présentiel exceptionnel ; (2) les jours multi-personnes sont éclatés en une ligne par personne présente (le schéma reste "une ligne = une personne") ; (3) "toute l'équipe" désigne les 5 personnes suivies (Thomas, Antoine, Charlyne, Lisa, Maëlle) **plus** Martin Pavloff, soit 6 personnes ; (4) les personnes hors roster actuel (ex-alternantes sorties des effectifs) ne sont pas ajoutées au suivi, leurs lignes sont retirées au même titre que le cas (1).
- **D42** — Exécution de l'affinage (D41) via migration dédiée (`supabase/migrations/20260827000002_affinage_43_jours_d33.sql`), vérifiée par requête de contrôle indépendante après exécution : 9 lignes supprimées, 33 lignes confirmées (id existant conservé), 31 nouvelles lignes créées (éclatement multi-personnes). Résultat final vérifié : 77 lignes `presentiel_exceptionnel` confirmées, 1 en attente (tournage futur du 22/09/2026, à retraiter après réalisation), 12 `tt_exceptionnel` inchangées — total 90 lignes.
- **D38** — Quatre éléments du prompt fondateur initial de Perimeter, jamais formellement tranchés, sont actés comme reportés (même statut que les azimuts déjà reportés) : la checklist des éléments nécessaires aux projets du jour/semaine ; la proposition de candidature avec lettre de motivation suivant template Canva ; le rappel des impératifs (distinct des majorations de dates D18) ; la proposition de sous-tâches via agents (probable V3, jamais actée comme telle). Identifiés lors d'un audit de cohérence contre le prompt fondateur d'origine.
- **D39** — Dette technique soldée : la colonne `confirme` (D37), appliquée en production le 25 août 2026 sans être versionnée, est désormais documentée dans une migration dédiée (`supabase/migrations/20260827000001_add_confirme_column.sql`).
- **D43** — Rotation annuelle du board Monday (D33) : le numéro de board, jusqu'ici codé en dur à deux endroits dans le workflow `PERIMETER_MANAGEMENT_EQUIPE_PRESENTIEL_TT` (node Monday natif + requête GraphQL), est centralisé dans un node de config unique (`Config Board ID Saison`). Toute référence au board passe désormais par ce point unique — la mise à jour annuelle se limite à éditer cette seule valeur.
- **D44** — Rotation annuelle du board Monday : niveau d'automatisation retenu = rappel seul. La duplication du board et l'archivage de l'ancien restent des gestes manuels — jugés trop sensibles (archivage quasi irréversible pour toute l'équipe) pour une exécution automatique sans validation humaine. Nouveau workflow n8n dédié `PERIMETER_RAPPEL_ROTATION_BOARD` : Schedule Trigger quotidien, Code node calculant le dernier jour ouvré avant le 8 octobre de l'année en cours (week-ends gérés, jours fériés non couverts), email de rappel via SMTP Gmail (mot de passe d'application) listant les 3 étapes manuelles à effectuer.
- **D45** — Azimut Calendrier & temps, deuxième source Outlook (app registration Azure) : app "Perimeter Outlook Sync" créée sur le tenant L'Etudiant (single-tenant), credential OAuth2 connecté dans n8n et validé sur données réelles (5 événements du calendrier de Martin remontés). Scopes délégués : `Calendars.Read`, `offline_access`, `User.Read`. Piège documenté : l'endpoint `/common/` est invalide pour une app single-tenant (erreur AADSTS50194), remplacé par l'endpoint spécifique au tenant dans les URLs Authorization/Token. Le tenant bloque le consentement utilisateur standard quels que soient les scopes demandés — Martin a validé lui-même via le formulaire d'approbation, sans passer par un ticket IT formel. Secrets (Client ID, Tenant ID, Client Secret) stockés dans Bitwarden, jamais versionnés dans le repo. Reste à construire : le pipeline effectif de lecture calendrier comme deuxième source pour le poids journée (D16), avec conversion du fuseau horaire (Microsoft Graph renvoie les `dateTime` en UTC sans décalage).
- **D46** — Pipeline n8n Outlook construit et exécuté de bout en bout (D16/D45). Décisions actées pendant la construction : (1) pas de dédup Google/Outlook — les deux calendriers sont disjoints (perso vs pro), les heures de réunion se cumulent simplement ; (2) détection terrain/tournage : le champ `location` est absent des événements Outlook remontés par l'automatisation Monday→Outlook — Monday (board `5033664702`, même logique que D37 : filtre Pôles, Statut Prod, Resp. Tournage/Responsable Backup) devient la **seule** source de vérité pour le signal terrain de D16, la détection par champ Lieu (Google) est abandonnée pour ce signal ; (3) méthode de travail actée pour la suite du chantier n8n de Perimeter : Cursor édite le JSON du workflow (`n8n-workflows/xkS15S1PWCDYULRv.json`), synchronisé avec l'instance n8n locale via l'API REST n8n (`PUT /api/v1/workflows/{id}`) plutôt que par Import/Export manuel — script `n8n-workflows/sync_workflow.sh {id} pull|push`, clé API dans `~/.config/perimeter/n8n_api_key` (jamais versionnée). Test d'exécution complet réussi une première fois, puis un bug de configuration (`limit: 5` oublié sur le node Outlook depuis la phase de test initiale, jamais mis à `returnAll: true`) a été détecté par comparaison avec le calendrier réel de Martin et corrigé. Le re-test final après correction a été bloqué par une limitation de débit de l'API Monday.com ("too many requests", provoquée par les nombreuses exécutions successives de la session) — **non rejoué avant la fin de session, reste en dette pour la prochaine**.
- **D47** — Réouverture du scope azimuts. Audit de cohérence contre le prompt fondateur initial (8 septembre 2026) : sur 17 items du prompt d'origine, seul le time count présentiel/TT (D33) était construit de bout en bout ; le recentrage V1 à 4 azimuts (D10, D13) avait fait perdre l'essentiel de l'ambition initiale. Décision de fond : Perimeter n'a de sens que s'il permet un tour complet des sujets préoccupants, pro et perso à égalité.
- **D48** — Azimuts pro réactivés (4) : Boîte mail, Veille sectorielle, Visibilité & réseaux, Administratif & budget. Scope pro complet : 8 azimuts (étendu à 10 par D54/D55/D56).
- **D49** — Azimuts perso réactivés (3) : Loisirs, Finances perso, Domicile — rendus possibles par l'élargissement des sources automatiques disponibles (Boîte mail, réactivée D48, en plus du Calendrier déjà acté D11). Règle D11 (pas de saisie manuelle pure côté perso) explicitement maintenue, aucun assouplissement. Scope perso complet : 5 azimuts.
- **D50** — Scope total acté : 13 azimuts (8 pro + 5 perso). La distinction "azimuts V1 / reportés" est dépréciée en section 3 — tous les azimuts existent dans le cercle, seule leur profondeur de construction suit encore la logique d'itération (D13).
- **D51** — Moteur d'interprétation Ollama (Calendrier + Mail) identifié comme brique prioritaire transverse plutôt qu'une construction azimut par azimut. D31 (points calendrier) et D28 (lecture mail Management) convergent vers un même moteur "signal Calendrier/Mail → point catégorisé par azimut", potentiellement exploitable par 8 des 13 azimuts (Calendrier & temps, Boîte mail, Santé, Famille & proches, Loisirs, Finances perso, Domicile, Management d'équipe). Chantier de conception à ouvrir, non cadré techniquement à ce stade. **Cadrage et implémentation terminés le 9 septembre 2026 — voir D57 à D68.**
- **D52** — Les 4 éléments D38 requalifiés maintenant que le scope est rouvert : checklist projets jour/semaine → sous-fonctionnalité Pilotage de projets ; candidature + lettre Canva → sous-fonctionnalité Carrière & opportunités ; rappel des impératifs → capacité transverse du Tour ; sous-tâches via agents → capacité transverse du Tour, reste V3.
- **D53** — Dette de design identifiée : la direction visuelle du cercle (D24-D26) a été pensée et calculée (seuils D15, k de normalisation D26) pour 4 azimuts. Le passage à 13, puis 15 (D56), impacte la lisibilité et nécessite une révision de ces paramètres — chantier de design à part entière, pas un simple ajustement de config.
- **D54** — Azimut "Énergie & charge mentale" réactivé, recoupe partiellement la majoration réunions déjà actée (D16), à enrichir au-delà des seules réunions (pauses, récupération). Source auto : Calendrier.
- **D55** — Azimut "Mémoire & connaissance" : réouverture actée sur le principe (tour complet, D47), mais azimut non opérationnel — aucune source automatique fiable identifiée à ce jour (journal de décisions, base de contacts). Contrainte D11 maintenue sans exception : pas de saisie manuelle en attendant. Chantier de recherche de source à mener avant activation.
- **D56** — Scope total réactualisé : 15 azimuts (10 pro dont 1 en attente — D55 — et 5 perso).
- **D57** — Moteur Ollama, hôte : Mac Maison — le même Mac qui héberge déjà n8n en Docker pour ce workflow, pour éviter tout tunnel réseau (le node HTTP Request de n8n appelle Ollama en local).
- **D58** — Modèle IA du moteur Ollama : **Ministral 3 8B** (tag Ollama `ministral-3:8b`), remplace Mistral 7B (D22) — même contrainte RAM (16 Go Mac Maison) respectée, sortie JSON structurée native mieux adaptée à l'usage. Attention au nom : "Ministral 3" (gamme edge de Mistral AI), pas "Mistral 3" — deux gammes distinctes chez le même éditeur.
- **D59** — Contrat d'interface n8n ↔ Ollama : un seul prompt système générique, réutilisé par les 8 azimuts exploitables par le moteur (D51), plutôt qu'un prompt dédié par azimut — cohérent avec la Loi 2 du Workflow Captif (pas de convention qui varie d'un azimut à l'autre sans décision explicite).
- **D60** — Format de sortie JSON du moteur Ollama acté : `azimut` (enum des 8 azimuts exploitables), `est_un_point` (booléen, D64), `resume` (texte libre, une phrase factuelle), `urgence` (entier, échelle D63), `urgence_label` (enum à 5 valeurs), `action_suggeree` (texte libre, D61).
- **D61** — `action_suggeree` : texte libre rédigé par le modèle, pas de liste fermée d'actions types — laisse la porte ouverte à des actions semi-automatisées/boutons plus tard, mais non retenu pour cette première version.
- **D62** — Piège documenté : une contrainte de format donnée uniquement en texte dans le prompt système (noms de champs exacts, interdiction de bloc markdown en fin de réponse) n'est pas fiable — Ministral 3 8B l'a ignorée deux fois de suite sur des points précis (accent ajouté à un nom de champ, bloc ``` résiduel). Le paramètre `format` d'Ollama (schéma JSON strict, type/enum/required) résout le problème de manière mécanique. Règle actée : toute contrainte de structure doit passer par ce paramètre, jamais par une instruction textuelle seule.
- **D63** — Correction de D60 : l'échelle d'urgence du moteur Ollama est **1 à 5**, alignée sur D26 (pas 0-3 comme envisagé dans une première passe) — évite de recalculer les seuils D15 et les constantes `k` D26 déjà dérivés d'une urgence médiane de 3 sur une échelle 1-5. Labels associés : 1 faible, 2 normale, 3 élevée, 4 très élevée, 5 critique. Testé et validé sur Ministral 3 8B avec schéma JSON strict.
- **D64** — Filtrage des faux positifs : champ booléen `est_un_point` ajouté au format de sortie (option retenue), plutôt qu'une valeur `"aucun"` dans le champ `azimut` (option écartée pour raison de clarté sémantique) — `azimut` reste toujours une vraie catégorie parmi les 8, `est_un_point` décide seul si la ligne part vers Supabase ou est écartée par n8n.
- **D65** — Réseau confirmé : depuis le conteneur Docker `n8n-perimeter` (D30), Ollama est joignable via `http://host.docker.internal:11434` — fonctionne nativement sur Docker Desktop macOS, aucune configuration réseau additionnelle nécessaire. Piège documenté pour référence future : `localhost` depuis l'intérieur du conteneur pointe vers le conteneur lui-même, jamais vers le Mac hôte.
- **D66** — Deux migrations Supabase sur la table `points`, nécessaires avant tout insert réel du moteur Ollama : (1) contrainte `azimut` élargie de 4 à 10 valeurs (les 4 azimuts V1 + les 6 azimuts nouveaux exploitables par le moteur hors Calendrier/Management déjà présents — Boîte mail, Santé, Famille & proches, Loisirs, Finances perso, Domicile) ; les 5 azimuts restants (Visibilité & réseaux, Veille sectorielle, Administratif & budget, Énergie & charge mentale, Mémoire & connaissance) ne sont pas ajoutés, aucun pipeline construit derrière à ce stade ; (2) colonne `event_id` ajoutée + contrainte `UNIQUE(source, event_id)`, pour permettre un upsert (`on_conflict`) et éviter la réinsertion en doublon d'un même événement calendrier à chaque exécution du workflow — piège identifié et corrigé avant mise en production (contrairement à D39 sur `presentiel_tt_evenements`, découvert après coup).
- **D67** — Mapping des champs du moteur Ollama vers le schéma `points` existant, sans nouvelle colonne : `resume` → `libelle` ; `azimut` et `urgence` inchangés ; `urgence_label`, `action_suggeree`, `est_un_point`, `event_date` stockés dans `donnees_brutes` (jsonb). Choix par défaut, réversible sans perte de données si un besoin de requêtage SQL direct apparaît plus tard.
- **D68** — Pipeline moteur Ollama câblé de bout en bout dans le workflow n8n `xkS15S1PWCDYULRv` (`n8n-workflows/xkS15S1PWCDYULRv.json`), en parallèle du calcul `poids_journee` existant (D16/D46), sans le modifier : Get many events (Google) + Get many events Outlook → Préparer signaux Ollama (Code) → Appel Ollama (HTTP Request, schéma JSON strict) → Parser réponse Ollama (Code) → Filtrer points valides (Filter, `est_un_point = true`) → Insérer point Supabase (HTTP Request, upsert `on_conflict=source,event_id`). Synchronisé en production via `sync_workflow.sh push`, confirmé (`updatedAt` mis à jour). Champ Outlook `location?.displayName` non vérifié sur une vraie sortie — à confirmer à la première exécution réelle.

---

## 10bis. État d'implémentation (25 août 2026)

Premier azimut construit de bout en bout : **Calendrier & temps — poids journée (D16)**.

Pipeline fonctionnel : Google Calendar (OAuth2) → n8n (local, Docker) → calcul du poids journée → Supabase (table `contexte_journee`). Testé avec une donnée réelle, confirmé dans le Table Editor.

Ce qui n'est pas encore couvert par ce premier azimut : les "points" proprement dits (D31, reporté), la source Outlook (reportée), le déclenchement automatique à l'ouverture de session (D5, encore manuel à ce stade).

### 10ter. État d'implémentation — Suivi Présentiel/TT (D33, 25 août 2026)

Pipeline complet et validé de bout en bout : API Monday.com en GraphQL direct avec pagination par curseur (le node natif "Get Many Items" plafonnait silencieusement à 240 items sur les 814 du board, sans erreur — contournement nécessaire) → Code node de classification (deux rythmes D34/D36, filtre Pôles D37, repli Resp. Tournage → Responsable Backup → attribution par défaut D37) → Supabase (`presentiel_tt_evenements`).

Résultat vérifié par recalcul indépendant depuis l'export Excel du board (pas seulement testé — confronté ligne à ligne à une source externe) : **68 lignes en base initialement** — 12 `tt_exceptionnel` + 56 `presentiel_exceptionnel` (jours uniques par personne). Sur ces 56, 13 étaient confirmés (`confirme = true`) et 43 étaient des estimations par défaut (`confirme = false`) — chiffre corrigé en D40 après une erreur de comptage du 25 août.

**Mise à jour du 27 août 2026 (D41/D42)** — Affinage complet des 43 jours non confirmés, vérifiés manuellement un par un par Martin (mail/Teams/calendrier). Résultat : 9 lignes supprimées (pas de présentiel réel, ou personnes hors roster actuel), 33 lignes confirmées, 31 nouvelles lignes créées (éclatement des jours multi-personnes). **État final : 90 lignes en base** — 12 `tt_exceptionnel` + 78 `presentiel_exceptionnel`, dont 77 confirmées et 1 en attente (tournage du 22/09/2026, pas encore réalisé).

**Mise à jour du 28 août 2026 (D43/D44)** — Rotation annuelle du board traitée : le board ID est désormais centralisé dans un node de config unique, et un workflow séparé envoie un rappel email automatique au dernier jour ouvré avant le 8 octobre. La duplication du board et l'archivage de l'ancien restent des gestes manuels (choix assumé, D44).

Ce qui manque encore : déclenchement automatique du workflow principal (D5, toujours manuel) ; affinage des jours non confirmés via d'autres sources ; le jour du 22/09/2026, en attente du tournage.

### 10quater. État d'implémentation — Connexion Outlook (D45, 7 septembre 2026)

Connexion OAuth2 établie et validée de bout en bout : app registration Azure (tenant L'Etudiant, single-tenant) → credential n8n "Microsoft Outlook account" → test réussi sur données réelles (5 événements du calendrier de Martin remontés via un mini-workflow de test, sujets/horaires/participants cohérents).

Ce qui n'est **pas encore** construit : le pipeline de production qui consommerait Outlook comme deuxième source calendrier pour le poids journée (D16), en complément de Google Calendar. La conversion UTC → Europe/Paris n'a pas encore été implémentée — les `dateTime` bruts renvoyés par Microsoft Graph sont en UTC sans décalage.

### 10quinquies. État d'implémentation — Pipeline Outlook + Monday pour le poids journée (D46, 7 septembre 2026)

Pipeline construit et exécuté de bout en bout dans le workflow n8n `xkS15S1PWCDYULRv` (fichier `n8n-workflows/xkS15S1PWCDYULRv.json`) : Google Calendar + Outlook (fusionnés, sans dédup) → détection terrain via cross-check Monday (nouveau Code node "Détection tournage Martin (jour)", réutilise la logique D37 filtrée sur Martin et la date du jour) → calcul `poids_journee` (D16) → Supabase `contexte_journee`. Conversion UTC → Europe/Paris faite via Luxon natif du Code node (`$now.setZone('Europe/Paris')`, `DateTime.fromISO(..., { zone: 'utc' }).setZone('Europe/Paris')`).

Un premier test complet a réussi mais avec un sous-comptage des événements Outlook (`limit: 5` resté configuré depuis la phase de test initiale). Corrigé (`returnAll: true`) et **confirmé le 08/09/2026** : 3 événements Outlook / 2h48 de réunions cumulées calculés contre 2h45 réellement prévues sur le calendrier — écart négligeable, cohérent avec un arrondi. Le pipeline est considéré fiable et clos.

Nouvel outil créé pendant ce chantier, réutilisable pour tout futur travail sur les workflows n8n de Perimeter : `n8n-workflows/sync_workflow.sh {id} pull|push`, qui synchronise un fichier JSON local avec l'instance n8n en direct via son API REST (`PUT /api/v1/workflows/{id}`), évitant l'export/import manuel.

### 10sexies. État d'implémentation — Moteur d'interprétation Ollama (D51, D57-D68, 9 septembre 2026)

Chantier ouvert et clos dans la même session (réouverture du scope azimuts, 8-9 septembre 2026). Ollama installé et testé sur Mac Maison, modèle Ministral 3 8B téléchargé (6 Go). Prompt système unique validé par tests réels (cas positif « RDV plombier » → `domicile`/`est_un_point: true`, cas négatif « réunion récurrente » → `est_un_point: false`), avec contrainte de structure imposée par le paramètre `format` d'Ollama plutôt que par le texte du prompt (D62).

Deux migrations Supabase passées sur la table `points` (D66) : élargissement de la contrainte `azimut` à 10 valeurs, ajout de `event_id` + contrainte d'unicité `(source, event_id)` pour permettre l'upsert et éviter les doublons à chaque exécution du workflow.

Branchement n8n réalisé via la méthode déjà actée en D46 (Cursor édite le JSON du workflow, `sync_workflow.sh push` synchronise) : cinq nouveaux nodes ajoutés en parallèle du calcul `poids_journee`, sans toucher aux nodes existants. Piège réseau Docker → Mac résolu via `host.docker.internal` (D65).

**Ce qui n'est pas encore couvert :** seules les sources calendrier (Google + Outlook) alimentent le moteur à ce stade — la source Boîte mail (nécessaire pour Boîte mail, Finances perso, et une partie de Loisirs/Domicile) n'a aucun pipeline n8n construit à ce jour. Le champ Outlook `location?.displayName` n'a pas encore été vérifié sur une vraie sortie (à confirmer à la première exécution réelle du workflow). Le test d'exécution réelle du workflow complet (bouton "Execute workflow" dans n8n, vérification d'une ligne dans `points`) restait à faire à la clôture de cette session.

---

## 11. Ce qui reste à trancher

- Mise en place concrète du workflow n8n annuel de récupération automatique des dates Parcoursup
- Suivi Présentiel/TT (D33) : rotation annuelle du board traitée en D43/D44 (config centralisée + rappel email) — reste la duplication/archivage manuels à faire chaque année, et le retraitement du jour du 22/09/2026 une fois le tournage réalisé. Déclenchement automatique du workflow principal (D5) toujours manuel.
- Migration n8n vers Oracle Cloud Free Tier (D30/D21) — toujours pertinente pour lever la dépendance au Mac Maison sur les workflows nécessitant Docker local
- Dette technique restante : le schéma Supabase initial (24 août — `points`, `tours`, `contexte_journee`) n'a jamais été versionné sur GitHub — à corriger à l'occasion, non bloquant (la colonne `confirme`, elle, est désormais versionnée — D39)
- Les 4 éléments reportés en D38 : checklist projets jour/semaine, candidature + lettre de motivation (template Canva), rappel des impératifs, sous-tâches via agents — aucun n'a de chantier dédié ni d'azimut d'accueil clair pour l'instant, à recadrer le moment venu.
- Fusion Google Calendar / Outlook (D16 + D45) : les deux sources devront être dédupliquées si un même événement apparaît dans les deux calendriers — règle de priorité ou de fusion pas encore définie.
- Seuils de volume (D15) et constantes de normalisation k (D26) à définir pour les 9 nouveaux azimuts — actuellement seuls Calendrier, Monday, Carrière, Management ont des valeurs actées
- Chantier design du cercle à 15 azimuts (D53) — lisibilité, labels, répartition visuelle
- Section 9 "Roadmap en itérations" à revisiter — elle décrit encore V1 comme "les 4 azimuts retenus", devenu inexact avec 15 azimuts actés (signalé par Cursor le 8 septembre 2026)
- Trouver une source automatique fiable pour l'azimut "Mémoire & connaissance" (D55) — condition d'activation, pas de saisie manuelle en attendant
- Construire le pipeline n8n de lecture Boîte mail (D48) — condition pour que le moteur Ollama (D51/D57-D68) couvre les azimuts Boîte mail, Finances perso, et la partie mail de Loisirs/Domicile, aujourd'hui seulement câblés côté Calendrier
- Vérifier le champ Outlook `location?.displayName` sur une vraie sortie du node "Get many events Outlook" (supposition non confirmée dans le Code node "Préparer signaux Ollama", D68)
- Exécuter le workflow `xkS15S1PWCDYULRv` en conditions réelles (bouton "Execute workflow") et vérifier l'insertion effective dans `points` — dernière vérification non faite à la clôture de cette session

---

*Document vivant — à mettre à jour à chaque session de travail sur Perimeter.*
