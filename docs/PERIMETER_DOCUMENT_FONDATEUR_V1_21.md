# PERIMETER — Document Fondateur

*Projet personnel de Martin Pavloff — hors Tranquility Suite*
*Version 1.21 — 26 septembre 2026 (soir)*

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
- **Boîte mail** *(réactivé D48)* — tri, relances, résumés, deadlines cachées, proposition de réponses aux mails éligibles. Sources opérationnelles : Gmail perso (D75-D78) et Outlook pro (D82/D83, 26/09/2026). Règle newsletter D84 actée, mise en œuvre à faire
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

### Direction visuelle (D24, remplacé intégralement par D79 ; encodage visuel amendé par D80 ; thème sombre étendu par D81 ; rendu du prototype précisé par D85 ; logo versionné D86)

**D79 — Master Design & Art Direction Brief.** La direction "papier & encre" initiale (D24 : IBM Plex, cercle à bord intérieur variable, épaisseur de trait plafonnée) est abandonnée au profit d'un brief complet de direction artistique, de facture suisse/néo-grotesque et proche des standards de documentation NASA (sans reprendre le dark theme Tranquility — identité Perimeter distincte maintenue) :

- **Palette** : Obsidian / Ivory / Paper / Slate (tokens `--perimeter-obsidian`, `--perimeter-ivory`, `--perimeter-paper`, `--perimeter-slate`), dérivés (`--perimeter-hairline`, `--perimeter-ink-faint`) via `color-mix()`. Le rouge de rubrication (`#A13A22`) et le vert sauge (`#5C7A5E`) de D24 sont conservés tels quels, seule la base neutre change.
- **Typographie** : **Inter** (400/500/600/700), choisi comme équivalent libre aux références du brief (Akzidenz-Grotesk / Helvetica / Neue Haas Grotesk, non libres de droits) — remplace IBM Plex Sans/Mono. `font-variant-numeric: tabular-nums` remplace le recours à une police mono dédiée pour l'alignement des données chiffrées.
- **Primitifs** : Typographie, Ivoire, Obsidienne, Grille, Hairline, Cercle, Point, Espace vide — sept éléments et rien d'autre. Symbolique **Cercle + Point = "Champ → Signal"**, qui devient le motif central de toute l'identité Perimeter (voir logo, D80).
- **Anti-décoration stricte** : aucune carte, ombre, dégradé, coin arrondi (sauf le cercle et les boutons pilule), aucun emoji dans l'UI.
- **Trois états** : Veille / Analyse / Alerte — l'état Alerte est une inversion pure obsidienne/ivoire, sans clignotement ni glow.

**D80 — Abandon de la piste organique ("Arrival"), retour au primitif Cercle + Point aligné sur le logo réel.** Une exploration a été menée pour donner au cercle une texture organique inspirée des logogrammes du film *Arrival* de Denis Villeneuve (fusion de formes via filtre SVG "gooey", contour bruité, tentacules asymétriques portant la charge au-delà d'un seuil) — jugée non concluante après retour direct de Martin ("ça ne me va pas du tout, on est allés beaucoup trop loin") et abandonnée sans ambiguïté.

Retour tranché à la source la plus simple et la plus forte : **le logo Perimeter existant** (cercle plein avec point ivoire en réserve ; variante cercle hairline avec point obsidienne plein — les deux sur fond papier grainé). Traduction retenue pour le cercle à 15 azimuts :

- **Cercle en trait fin** (hairline, ~2px), légèrement irrégulier (bruit d'amplitude minime, ~1-2px, deux fréquences superposées — un reste d'"encre", pas une déformation organique) — remplace le tracé à main levée à bord intérieur variable de D24.
- **Un point plein par azimut**, posé sur le tracé du cercle. **La taille du point encode la charge** (D26 : normalisation `charge/(charge+k)` inchangée dans son calcul — seul son mode d'affichage change, de l'épaisseur d'anneau vers la taille de point). L'épaisseur d'anneau variable de D24/D26 est donc abandonnée comme représentation visuelle, sans toucher à la formule de charge elle-même (D9, D14-D20, D26).
- **Ligne et points toujours en noir** (obsidienne) sur fond clair — aucune distinction de couleur entre azimut normal et azimut en seuil ; le seul marqueur de seuil reste le texte "seuil" en rouge de rubrication, dans la légende numérotée (pas sur le cercle lui-même).
- **Grain de papier** en fond, généré en SVG (`feTurbulence` + `feColorMatrix`, sans asset externe), pour rester dans la texture du logo plutôt que du flat design pur.
- **Labels en retrait** (D24, inchangé) : la légende numérotée à droite du cercle reste l'endroit où la précision (nom, points, seuil) se lit ; le cercle porte l'impression d'ensemble.

**D81 — Thème sombre : inversion générale, pas seulement l'état Alerte.** Dès que l'application passe en thème sombre (indépendamment de tout état Alerte), la ligne du cercle et les points s'inversent systématiquement en négatif (blanc sur noir). Ce n'est pas une simple confirmation du comportement déjà prévu pour l'état Alerte au Master Brief (D79) : c'est une règle plus générale, actée comme telle, qui s'applique à tout le primitif Cercle + Point quel que soit l'état fonctionnel affiché.

**D85 — Précisions de rendu actées lors du portage dans le prototype réel (26 septembre 2026).**

- **Séquence 4 (avant / après)** : les deux tracés restent entièrement en obsidienne, sans opacité réduite ni gris sur le « avant » — seule la taille des points montre l'allègement. Application stricte de D80 (option retenue par Martin parmi trois : gris `ink-faint`, tout noir, contour évidé).
- **Légende de la séquence 2** : triée par charge décroissante ; le numéro affiché est le rang (01 = azimut le plus chargé), plus l'index d'azimut ; la séparation visuelle pro / perso est supprimée (sans objet une fois la liste triée). Le cercle, lui, garde les positions angulaires fixes de chaque azimut.
- **Colonne %** ajoutée à la légende, entre le nom et les points, en obsidienne (c'est la clé de tri). Format unique `formatPct` partagé entre la légende et la valeur centrale au survol : arrondi entier + espace fine insécable (U+202F) + `%`. Colonnes chiffrées à largeur fixe, colonne « seuil » toujours réservée même vide, pour l'alignement.
- **Stepper** : le `box-shadow` du point courant est remplacé par un `outline` au rendu identique — anti-décoration D79 appliquée sans exception.
- **Grain de papier** : un calque unique pour toute la page (SVG fixe, `feTurbulence`), plutôt qu'un rectangle par SVG de cercle — évite un bord de carré visible.
- **Inter 700** chargé explicitement (la légende en 700 retombait sinon sur un gras synthétique).

**D86 — Logo Perimeter versionné** dans `design/logo/` : deux PNG sources fournis par Martin (1254 px, fond papier grainé — référence d'origine) et deux SVG vectoriels produits en session (cercle et point reconstruits géométriquement à partir de mesures sur les PNG ; mot « Perimeter » vectorisé via potrace, séparément pour chaque variante). Les SVG ne portent aucune couleur en dur (`currentColor`) : le thème sombre D81 s'obtient en changeant la seule couleur de texte du conteneur. Variante pleine : point et lettres en réserve réelle (`fill-rule: evenodd`), le fond apparaît au travers. Grain de papier absent des SVG — à ajouter à l'affichage si voulu. Emplacement `design/logo/` plutôt qu'`assets/` : `assets/` n'aura de sens qu'à la création de l'app, les fichiers y seront alors copiés depuis `design/logo/`, qui reste la source.

Prototype de travail : maquettes interactives construites dans un canvas de design séparé (deux options comparées — index numéroté au survol, retenue ; labels rayonnants, écartée) avant la piste Arrival, puis reconstruites après son abandon. **Portage vers le prototype réel du repo (`design/perimeter_parcours_prototype_v3.html`) fait le 26 septembre 2026** — voir 10duodecies.

### Parcours en 4 séquences (D25)

Un stepper à 4 points matérialise l'avancement :

1. **Ouverture / lancement** — cercle neutre (charge non affichée), bouton "Lancer le tour"
2. **Tracé avec charge réelle** — le cercle tel que décrit ci-dessus, azimut par azimut
3. **Compte-rendu + plan d'action** — le cercle se réduit en médaillon, liste d'actions triée par charge décroissante, barre de progression globale
4. **Fin de tâche — avant/après** — deux tracés (avant estompé, après net) avec le delta chiffré par azimut, preuve visuelle que le tour a allégé la charge

Prototype de référence : `design/perimeter_parcours_prototype_v3.html` (D79, D80, D85 appliqués ; 15 azimuts).

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
- **D69** — Premier test réel du workflow `xkS15S1PWCDYULRv` (18 septembre 2026) : 3 bugs bloquants corrigés (mode d'exécution du node "Parser réponse Ollama" en "Each Item" et non "All Items" ; format de retour ajusté en conséquence ; dédoublonnage des événements Outlook ajouté après "Get many events Outlook", l'API Microsoft Graph renvoyant certains événements en double sur la pagination `Return All`). Résultat validé dans Supabase : 3 points insérés, un par événement réel, zéro doublon — premier succès de bout en bout du pipeline Google/Outlook → Ollama → Supabase. Dans "Préparer signaux Ollama", conversion Europe/Paris ajoutée pour l'heure de début Outlook (19 septembre 2026) — les `dateTime` bruts renvoyés par Microsoft Graph sont en UTC sans décalage et n'étaient pas convertis, contrairement à ce qui est déjà fait dans le node `poids_journee` depuis D46.
- **D70** — Retry avec délai (4 tentatives, 8 secondes d'attente) ajouté sur les trois nodes du workflow `xkS15S1PWCDYULRv` qui appellent l'API Monday ("Get items item by column value (Télétravail)", "Monday GraphQL page 1", "Monday GraphQL page 2"), contre le rate limit Monday ("too many requests") rencontré à plusieurs reprises en session de test. Filet de sécurité assumé comme non définitif — pas d'exploitation de l'en-tête `Retry-After`, pas de distinction entre erreur de quota et erreur définitive. Suffisant tant que Perimeter n'est utilisé qu'en session de travail (pas encore d'usage quotidien réel) ; à revoir si le rate limit réapparaît en usage de production.
- **D71** — Chantier D48 (pipeline Boîte mail) engagé, architecture actée avant codage : couverture des deux boîtes de Martin (Outlook L'Étudiant + Gmail perso, `pavloffmartin@gmail.com`), utilisation du node natif "Microsoft Outlook" de n8n plutôt qu'un contournement via credential OAuth2 générique + HTTP Request. Ce choix a un coût assumé : le node natif a une liste de scopes fixe et non éditable dans l'interface n8n (`Contacts.Read`, `Contacts.ReadWrite`, `Calendars.Read`, `Calendars.Read.Shared`, `Calendars.ReadWrite`, `Mail.ReadWrite`, `Mail.ReadWrite.Shared`, `Mail.Send`, `Mail.Send.Shared`, `MailboxSettings.Read` — [source officielle n8n](https://github.com/n8n-io/n8n/blob/master/packages/nodes-base/credentials/MicrosoftOutlookOAuth2Api.credentials.ts)), plus large que le principe de scope minimal suivi jusqu'ici (D45 : `Calendars.Read` seul). Retenu pour la rapidité de mise en œuvre plutôt que l'option alternative (credential générique scope minimal `Mail.Read` + HTTP Request direct sur Microsoft Graph).
- **D72** — Fenêtre de lecture mail actée pour les deux boîtes : union de deux critères — mails reçus aujourd'hui **OU** mails non lus (peu importe leur date), pour ne rien laisser passer. Dossier INBOX uniquement (exclut le spam de fait, aucun filtre dédié nécessaire).
- **D73** — Sur la boîte Gmail perso uniquement (pas Outlook pro) : détection des mails publicitaires/newsletters via le label natif Gmail `CATEGORY_PROMOTIONS` et l'en-tête technique `List-Unsubscribe` (lien de désabonnement direct, quand présent) — signal transmis tel quel au moteur Ollama dans le `signal_texte`, pour qu'il propose un désabonnement en `action_suggeree` sur l'azimut `boite_mail`, sans logique de détection heuristique côté prompt.
- **D74** — Blocage identifié sur l'app Azure "Perimeter Outlook Sync" : le tenant L'Étudiant interdit tout consentement utilisateur standard (vérifié via Enterprise Applications → Perimeter Outlook Sync → Permissions → onglet "Consentement de l'utilisateur", vide malgré plusieurs reconnexions avec authentification complète + 2FA). Les 4 scopes historiques de D45 (`Calendars.Read`, `offline_access`, `User.Read`, `openid`) ont en réalité été accordés par un administrateur réel du tenant (onglet "Consentement administrateur"), jamais en self-service comme supposé jusqu'ici. Les scopes ajoutés pour D71 (`Mail.ReadWrite` et associés) sont bien enregistrés sur l'app mais non consentis, et le bouton "Accorder un consentement d'administrateur" est grisé pour le compte de Martin (pas de rôle admin sur ce tenant). Décision : demander le clic d'un administrateur (Florian ou Wagner, service informatique) plutôt que de chercher un contournement technique — email envoyé le 19/09/2026. Chantier Outlook de D48 mis en pause dans l'attente de cette validation ; rien d'autre ne bloque la branche Gmail perso, indépendante de ce tenant.
- **D75** — Node natif Gmail retenu malgré son scope large et fixe (`gmail.labels`, `gmail.addons.current.action.compose`, `gmail.addons.current.message.action`, `mail.google.com`, `gmail.modify`, `gmail.compose` — [source officielle n8n](https://raw.githubusercontent.com/n8n-io/n8n/master/packages/nodes-base/credentials/GmailOAuth2Api.credentials.ts)), même logique que D71 sur Outlook : cohérence et rapidité plutôt qu'un scope minimal sur-mesure.
- **D76** — Garde systématique contre l'item fantôme `alwaysOutputData` ajoutée sur les trois boucles de "Préparer signaux Ollama" (Google, Outlook, Gmail). Règle à appliquer à toute future source ajoutée à ce node.
- **D77** — Fenêtre de lecture Gmail (D72) durcie : un mail non lu ne compte désormais que s'il a moins de 48h (fenêtre glissante) ; le principe "reçus aujourd'hui" (D72) reste inchangé et s'additionne en OR. Résout l'effet de bord identifié en fin de session du 20/09 (backlog de non-lus remontant sur plusieurs jours, 42 messages vus lors d'un test).
- **D78** — Piège n8n découvert et documenté pendant la mise en œuvre de D77 : un champ de paramètre contenant **deux blocs d'expression `{{ }}` distincts** échoue silencieusement — l'exécution "réussit" mais ne retourne que l'item fantôme `alwaysOutputData` (D76), sans message d'erreur, même quand chaque expression prise isolément est valide (vérifié empiriquement : la requête Gmail testée en clair dans Gmail fonctionne, testée via un seul bloc `{{ }}` dans n8n fonctionne, testée avec deux blocs `{{ }}` dans le même champ échoue systématiquement, y compris après rechargement de la page n8n). Contournement retenu, désormais la règle à appliquer pour toute expression n8n combinant plusieurs valeurs dynamiques dans un même champ : regrouper toute la logique dans **un seul bloc `{{ }}`**, en construisant la chaîne finale par concaténation JavaScript plutôt que d'insérer plusieurs `{{ }}` séparés. Piège distinct de celui déjà documenté sur `DateTime.now()` (D62/carnet) — deux limitations différentes du même moteur d'expression.

- **D79** — Master Design & Art Direction Brief adopté, remplace D24 intégralement : palette Obsidian/Ivory/Paper/Slate, typographie Inter (équivalent libre aux références non libres du brief), primitifs Typographie/Ivoire/Obsidienne/Grille/Hairline/Cercle/Point/Espace vide, symbolique Cercle + Point ("Champ → Signal"), anti-décoration stricte, trois états Veille/Analyse/Alerte (Alerte = inversion pure obsidienne/ivoire).
- **D80** — Piste organique "Arrival" (filtre gooey, contour bruité, tentacules) explorée pour le cercle à 15 azimuts, jugée non concluante et abandonnée. Retour au primitif Cercle + Point directement aligné sur le logo Perimeter réel : cercle hairline légèrement irrégulier, un point plein par azimut dont la **taille** encode la charge (remplace l'épaisseur d'anneau comme mode d'affichage — la formule de charge D9/D14-D20/D26 reste inchangée), ligne et points toujours noirs (aucune distinction de couleur par seuil, porté uniquement par la légende), grain de papier généré en SVG.
- **D81** — Thème sombre acté comme règle générale (pas limitée à l'état Alerte) : dès que l'application passe en thème sombre, la ligne du cercle et les points s'inversent systématiquement en négatif (blanc sur noir).
- **D82** — D73 étendu à la boîte Outlook pro : un mail portant l'en-tête `List-Unsubscribe` (lu via `internetMessageHeaders` de Microsoft Graph) est signalé au moteur Ollama comme newsletter/pub, avec son lien de désabonnement, sur le même format que Gmail. Pas d'équivalent de `CATEGORY_PROMOTIONS` côté Outlook : l'en-tête seul fait office de signal.
- **D83** — Lecture mail Outlook via un node HTTP Request appelant directement Microsoft Graph (`GET /me/mailFolders/inbox/messages`), authentifié par le credential Outlook existant (type prédéfini `microsoftOutlookOAuth2Api`) — amende D71 pour la lecture mail uniquement (le calendrier Outlook reste sur le node natif). Deux raisons vérifiées : le node natif lit `/me/messages`, soit tous les dossiers (constaté : une newsletter hors Boîte de réception remontée par le node de test) ; il n'expose pas `internetMessageHeaders`, indispensable à D82. Fenêtre D72/D77 appliquée en deux temps pour respecter D78 : côté Graph un seul critère (`$filter=receivedDateTime ge` maintenant − 48 h, un seul bloc `{{ }}`), côté code (« Préparer signaux Ollama ») le tri fin « reçu aujourd'hui à Paris OU non lu ». `$top=100` sans pagination (17 mails sur 48 h observés — vigilance si le volume monte). `onError: continueRegularOutput` : une erreur Microsoft ne bloque jamais le reste du pipeline. `event_source = outlook_mail` → source Supabase `moteur_ollama_outlook_mail`, distincte du calendrier (`moteur_ollama_outlook`).
- **D84** — Décision de principe (Martin, 26/09/2026) : **une newsletter avec lien de désabonnement est toujours un point, avec une urgence faible**, Gmail comme Outlook. Constat déclencheur : la newsletter industrie.school a été retenue mais classée `management_equipe`, urgence 3, par Ollama ; et une newsletter jugée « pas un point » perdait sa proposition de désabonnement. Mise en œuvre à faire en début de session suivante, dans le code et non dans le prompt (leçon D62) : dans « Parser réponse Ollama », si le signal porte la marque newsletter, forcer `est_un_point = true`, `azimut = boite_mail`, `urgence = 1` (« faible »), `action_suggeree` = désabonnement + lien — Ollama ne garde que la rédaction du résumé. Deux sous-questions à trancher avant de coder : (1) un point par expéditeur (identifiant = adresse d'expéditeur, l'upsert maintient une ligne par émetteur) plutôt qu'un point par mail — proposé par JARVIS pour éviter l'inflation de la charge Boîte mail ; (2) aligner la détection Gmail sur la seule présence de l'en-tête `List-Unsubscribe` (aujourd'hui limitée à `CATEGORY_PROMOTIONS`, qui laisse passer SeLoger, Belles Demeures, Facebook…).
- **D85** — Précisions de rendu du prototype, actées au portage D80 : avant/après tout en obsidienne, légende triée par charge (rang, %), format de pourcentage unique, stepper sans ombre, grain global — détail en section 6.
- **D86** — Logo Perimeter versionné dans `design/logo/` : 2 PNG sources + 2 SVG `currentColor` compatibles D81 — détail en section 6.
- **D88** — App OAuth Google du projet Cloud `perimeter` passée en statut **« En production »** (26/09/2026, soir), pour mettre fin à l'expiration des jetons à 7 jours propre au statut « Test ». Publication non validée par Google, assumée : usage strictement personnel, limite de 100 utilisateurs sans objet, écran « application non vérifiée » accepté à la connexion ; le bandeau « Votre application doit être validée » est ignoré volontairement, aucune soumission au centre de validation. Prérequis imposés par Google et non signalés comme obligatoires dans l'interface : page d'accueil, règles de confidentialité et domaine autorisé. Servis par un repo public dédié, **`RealCoolclint/perimeter-site`** (GitHub Pages : `https://realcoolclint.github.io/perimeter-site/` et `…/privacy.html`, domaine autorisé `realcoolclint.github.io`), volontairement séparé du repo `perimeter` pour que ces liens survivent à un éventuel retour en privé (D29). Aucun logo téléversé sur l'écran de consentement (un logo déclencherait une validation obligatoire). Credentials n8n « Google Calendar account » et « Gmail account » reconnectés après publication, pour obtenir des jetons sans échéance. La page de confidentialité décrit l'usage réel (lecture seule, analyse locale Ollama, conservation limitée à un résumé) : elle doit être tenue à jour si le périmètre des données lues évolue.
- **D87** — Règle de synchronisation n8n : toute modification faite dans l'éditeur n8n est suivie **immédiatement** d'un `sync_workflow.sh pull` ; un `push` ne part jamais d'un fichier local antérieur à la dernière modification faite dans l'interface. Origine : la correction D69 du node « Parser réponse Ollama » (mode Each Item), faite dans l'interface le 18/09, a été silencieusement écrasée par un push ultérieur — plus aucun point n'est arrivé dans Supabase du 18 au 26/09 sans qu'aucune erreur ne l'indique.

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

*(dépassé par 10nonies — pipeline Gmail construit et validé le 20/09)*

### 10septies. État d'implémentation — Première exécution réelle et durcissement (D69/D70, 18-19 septembre 2026)

**18 septembre 2026 — première exécution réelle du workflow `xkS15S1PWCDYULRv`, validée.** Trois bugs bloquants corrigés (D69) : mode d'exécution du node "Parser réponse Ollama", format de retour associé, dédoublonnage des événements Outlook en amont de la branche Ollama. Résultat vérifié dans Supabase : 3 points insérés, un par événement réel, zéro doublon. Le pipeline Google/Outlook → dédoublonnage → Ollama → parsing → filtrage → insertion Supabase est validé de bout en bout pour la première fois.

**19 septembre 2026 — diagnostic du champ Outlook `location?.displayName` vide.** Confirmé par Martin : les lieux concernés ("Studio Canapé", "Studio Pegboard", etc.) sont des configurations de tournage, renseignées uniquement dans Monday (colonne `LIEU`, id technique `label__1`, colonne de type Statut), jamais dans le champ Location d'Outlook — ce n'est pas un bug, c'est une source de données qui n'est simplement pas la bonne pour cette information.

**Défaut d'architecture découvert à cette occasion, antérieur à cette session (hérité de D46) :** le node "Détection tournage Martin (jour)" est branché en aval de "Get items item by column value (Télétravail)", qui ne récupère que les items Monday dont `Statut Prod = Absence` — or le code de "Détection tournage Martin (jour)" exclut explicitement les items `Statut Prod = Absence`. Conséquence probable : ce node n'a jamais pu détecter un vrai tournage depuis sa création, silencieusement (`tournage_martin_aujourdhui: false` par défaut, sans erreur). Non corrigé cette session — la correction du bon niveau (une requête Monday indépendante, dédiée, avec `alwaysOutputData` à chaque étape pour ne jamais pouvoir bloquer la branche Ollama) est un chantier à part entière, reporté à une session avec de vraies données de test (voir section 11).

**Tentative de correctif avortée, pour mémoire :** une tentative de faire remonter le lieu Monday jusqu'au signal Ollama (en couplant "Préparer signaux Ollama" à "Détection tournage Martin (jour)" via un node Merge) a été testée puis entièrement annulée en session : elle rendait toute la branche Ollama dépendante d'une chaîne Monday qui peut légitimement ne renvoyer aucun item (pas d'`alwaysOutputData`), ce qui aurait bloqué silencieusement l'ensemble du pipeline calendrier — Google et Outlook confondus — les jours sans item `Absence`. Repéré et annulé avant tout push en production. Seul reste acquis de cette exploration : l'id de colonne Monday `label__1` (Lieu) et la correction de casse `'Lieu'` dans le code de détection, tous deux sans risque et déjà en production.

**Durcissement du même jour (D70) :** retry avec délai ajouté sur les trois nodes du workflow qui appellent l'API Monday, contre le rate limit rencontré plusieurs fois en session de test (18 et 19 septembre). Pas une solution définitive, un filet de sécurité pour l'usage actuel (sessions de travail, pas de production quotidienne).

**Conversion de fuseau horaire corrigée en passant :** le node "Préparer signaux Ollama" affichait l'heure de début Outlook en UTC brut, jamais convertie en Europe/Paris (contrairement au node `poids_journee` qui le fait depuis D46). Corrigé dans la même session, sans effet de bord identifié.

### 10octies. État d'implémentation — Chantier Boîte mail (D48/D71-D74), cadrage bloqué sur consentement Azure (19-20 septembre 2026)

Chantier D48 engagé : architecture actée (D71, D72, D73 — voir section 10) avant tout codage n8n, conformément à la méthode habituelle (cadrage puis prompt Cursor). Aucun node n'a encore été ajouté au workflow `xkS15S1PWCDYULRv` — le blocage Azure (D74) est survenu avant l'étape de construction.

**Diagnostic complet mené en session, sans hypothèse non vérifiée :** ajout de `Mail.ReadWrite` seul dans l'app Azure → 403 Forbidden persistant malgré plusieurs reconnexions (y compris en navigation privée avec authentification + 2FA complète) → recherche de la cause réelle (scope fixe du node n8n, non éditable) → ajout des scopes manquants pour matcher exactement la liste par défaut du node → 403 toujours persistant → vérification directe dans Azure (Enterprise Applications, pas App registrations) → confirmation que le tenant bloque tout consentement utilisateur, y compris pour les scopes déjà "anciens". Chaque hypothèse a été testée avant d'être écartée plutôt que supposée.

**Ce qui reste à faire, dans l'ordre :** (1) un administrateur du tenant (Florian ou Wagner) clique sur "Accorder un consentement d'administrateur pour L'Etudiant" sur la fiche Enterprise Application de "Perimeter Outlook Sync" — email envoyé le 19/09/2026 ; (2) une fois débloqué, reconnecter le credential "Microsoft Outlook account" dans n8n et relancer le test isolé (node "Get many messages", limite 1) pour confirmer l'accès avant de construire quoi que ce soit dessus ; (3) construire les nodes de lecture mail (Outlook + Gmail), le node de préparation des signaux mail (avec détection newsletter/pub pour Gmail, D73), et le Merge vers "Appel Ollama" — un seul prompt Cursor, une fois les deux credentials validés par un test réel.

**Ce qui n'a pas encore démarré :** le credential Gmail perso (OAuth2, scope `gmail.readonly`) — non bloqué, à créer dès la prochaine session, indépendamment de l'issue côté Outlook/Azure.

*(dépassé par 10nonies — pipeline Gmail construit et validé le 20/09)*

### 10nonies. État d'implémentation — Pipeline Gmail construit et validé (D48/D72-D76, 20 septembre 2026)

Pipeline Gmail construit et validé en exécution réelle : credential OAuth2 connecté, node "Get many messages Gmail" câblé dans le workflow `xkS15S1PWCDYULRv`, boucle Gmail dans "Préparer signaux Ollama" avec détection newsletter D73 opérationnelle.

Le node "Get many messages Gmail" a `alwaysOutputData: true`, `limit: 50` (`returnAll: false`), et un filtre de recherche Gmail basé sur `in:inbox (is:unread OR after:<minuit Paris en epoch secondes via $now>)` — pas de `after:YYYY/MM/DD` car ce format exclut les résultats du jour même.

La branche Outlook reste bloquée par le consentement admin (D74).

### 10decies. État d'implémentation — Fenêtre Gmail durcie et piège des expressions multiples (D77/D78, 20 septembre 2026)

Décision D72 affinée en D77 : fenêtre glissante de 48h appliquée au critère "non lu", en plus du critère "reçu aujourd'hui" déjà acté, qui reste inchangé. Mise en œuvre bloquée par un piège n8n non documenté jusqu'ici (D78) : deux blocs d'expression `{{ }}` dans le même champ de paramètre produisent un échec silencieux (item fantôme `alwaysOutputData`, aucune erreur). Diagnostic mené par tests empiriques successifs (requête testée en clair dans Gmail directement, puis avec un seul bloc `{{ }}`, puis avec deux) plutôt que par hypothèse — la même discipline que celle qui avait permis de percer la vraie forme des données Gmail plus tôt dans la journée. Corrigé en regroupant toute la logique de calcul de dates dans un unique bloc `{{ }}` construit par concaténation JavaScript. Requête finale validée en exécution réelle :

```
in:inbox {{ '(after:' + Math.floor($now.setZone('Europe/Paris').startOf('day').toSeconds()) + ' OR (is:unread after:' + (Math.floor($now.setZone('Europe/Paris').toSeconds()) - 172800) + '))' }}
```

Modification appliquée et validée directement dans l'éditeur n8n (auto-sauvegarde serveur immédiate à chaque "Test step", pas de `push` distinct nécessaire cette fois), puis resynchronisée dans le fichier local via `sync_workflow.sh pull` pour cohérence.

---

### 10undecies. État d'implémentation — Chantier design D53, cercle à 15 azimuts (D79/D80/D81, 20 septembre 2026)

Session dédiée à la charte graphique et au design de Perimeter (D53), après réouverture explicite du chantier par Martin. Déroulé complet, dans l'ordre :

1. Adoption du Master Design & Art Direction Brief (D79), en remplacement intégral de D24. Choix du typeface Inter (libre) confirmé par Martin en lieu et place des références non libres du brief.
2. Application des nouveaux tokens et de la typographie au prototype réel `design/perimeter_parcours_prototype_v3.html` via prompt Cursor (fond ivoire, tokens `--perimeter-*`, Inter partout, `tabular-nums` sur les valeurs chiffrées, suppression des filtres de tremblé `wobble1-4` — cercle net). Un oubli (`.center-value` sans `tabular-nums`) corrigé dans un second prompt, signalé par l'auto-relecture de Cursor.
3. Chantier D53 proprement dit engagé dans un canvas de design séparé (deux maquettes comparées à données réelles : Option A "index numéroté au survol", Option B "labels rayonnants compressés") — Option A retenue par Martin, détail individuel au survol ajouté.
4. Premier retour de correction : le tracé (pics radiaux + numéros sur le cercle) jugé "trop informatique" — retiré au profit de points encastrés dans l'épaisseur de l'anneau.
5. Piste organique explorée sur demande explicite de Martin, inspirée des logogrammes du film *Arrival* (filtre SVG "gooey", contour bruité, tentacules asymétriques portant la charge au-delà d'un seuil) — Martin avait explicitement choisi d'assouplir l'encodage strict pour aller dans cette direction. Résultat jugé "pas du tout" satisfaisant après publication et visionnage — piste entièrement abandonnée (D80).
6. Martin fournit le logo Perimeter réel (deux variantes : cercle plein/point ivoire en réserve ; cercle hairline/point obsidienne plein, fond papier grainé) comme point de départ effectif. Reconstruction du cercle à 15 azimuts alignée sur ce logo : cercle hairline légèrement irrégulier, points pleins de taille variable (charge), sans contour, sans distinction de couleur par seuil, grain de papier généré en SVG. Trois ajustements fins validés dans la foulée : poids typographique de la légende monté à 700, retrait du contour sur les points, irrégularité minime du tracé du cercle. Correction finale : points repassés en noir plein uniforme (pas de gris pour les azimuts normaux), conformément à D81 précisé par Martin ("ligne et points toujours en noir, sauf en dark mode où on passe en négatif").
7. Version validée par Martin ("bouclé").

**Ce qui n'est pas encore fait :** portage de cette version validée dans le prototype réel `design/perimeter_parcours_prototype_v3.html` (actuellement encore sur la version D24/tokens D79 sans les points/cercle hairline de D80) ; le logo Perimeter fourni par Martin n'est pas encore versionné dans le repo (fichiers reçus en pièce jointe de conversation, pas encore à un chemin `design/` ou `assets/`) ; le thème sombre (D81) n'a pas de maquette construite à ce stade, seule la règle est actée ; l'option B ("labels rayonnants") n'a pas été mise à jour depuis l'abandon de sa comparaison avec l'option A — obsolète, à retirer ou clairement marquer comme archivée.

**Mise à jour du 26 septembre 2026 :** le portage et le logo sont faits (voir 10duodecies). Restent de cette liste : la maquette du thème sombre (D81) et le sort de l'Option B.

### 10duodecies. État d'implémentation — Portage D80, logo, déblocage Outlook et branche Outlook mail (D82-D87, 26 septembre 2026)

**Design (D53, suite).**
1. Le travail D79 du 20/09 (tokens `--perimeter-*`, Inter, suppression du tremblé) n'avait jamais été commité : il n'existait que sur le Mac de Martin, alors que le récap et le fondateur le disaient appliqué. Détecté au protocole de démarrage (le prototype sur `main` était encore en IBM Plex), commité avant tout autre travail (`7ba1ce1`).
2. Portage du cercle validé (canvas de design) dans `design/perimeter_parcours_prototype_v3.html` : cercle hairline irrégulier, 15 points dont la taille encode la charge, grain global, légende numérotée interactive (survol croisé point ↔ ligne), séquences 1 à 4 réécrites sur le même primitif (`0d01f35`). Affinages D85 : légende triée par charge, colonne %, format de pourcentage unique, stepper sans ombre (`0f3c6e5`).
3. Logo versionné (D86) : SVG vectoriels produits en session (`caa1f6b`), PNG sources (`278bbd1`).

**Outlook (D74 levé).** Florian (service informatique) a accordé le consentement administrateur ; vérifié dans Azure (Enterprise Applications › Perimeter Outlook Sync › Autorisations) : 18 autorisations Microsoft Graph déléguées en « Consentement administrateur », dont tous les scopes du node natif — un peu plus que le nécessaire (`Mail.Read`, `Mail.ReadBasic`, `Contacts.ReadWrite.Shared`…), écart noté vis-à-vis du principe de scope minimal. Credential n8n reconnecté sans écran de consentement ; lecture prouvée par le node isolé « TEST Mail.Read ». Snapshot `D74_outlook_mail_consentement_valide.json` (`1bf9ac1`).

**Branche Outlook mail (D82/D83).** Node « Get many messages Outlook » (HTTP Request Graph) inséré entre « Get many messages Gmail » et « Préparer signaux Ollama » ; quatrième boucle dans « Préparer signaux Ollama » (Cursor). Test isolé : 17 mails de la Boîte de réception sur 48 h, en-têtes présents (44 à 54 par mail), 2 `List-Unsubscribe` ; 2 retenus par la fenêtre D72/D77. Test en amont d'Ollama : 15 signaux (1 Google, 1 Outlook calendrier, 10 Gmail, 2 Outlook mail), signal newsletter Outlook présent.

**Régression découverte et corrigée (D87).** Au premier test complet, « Parser réponse Ollama » ne sortait qu'un item sur 15 : son mode était revenu à « Run Once for All Items », la correction D69 du 18/09 ayant été perdue — absente des snapshots D69 (19/09), D78 (20/09) et D74 (26/09). Aucun point n'était arrivé dans Supabase depuis le 18/09, Gmail compris : les tests du 20/09 s'arrêtaient à « Préparer signaux Ollama ». Corrigé dans l'interface (mode Each Item, retour d'un objet unique), puis `pull` immédiat. **Validation de bout en bout** : 15 signaux → 15 réponses → 2 points retenus → 2 lignes insérées, toutes deux `moteur_ollama_outlook_mail` (le mail d'Antoine Paley « Conception ateliers cellule » et la newsletter industrie.school — cette dernière mal classée, d'où D84). Snapshot `D83_outlook_mail_pipeline_valide.json` (`d254e89`), vérifié sans `pinData` ni contenu de mail.

**Incidents d'infrastructure rencontrés.** (1) *[résolu le soir même — D88]* Credential « Google Calendar account » expiré : l'app OAuth Google est probablement en statut « Testing », qui fait expirer les jetons à 7 jours — le credential Gmail, issu du même projet, est exposé au même problème. (2) Mail Supabase du 26/09 : le projet Perimeter allait être mis en pause pour inactivité de plus de 7 jours (free tier) — la chaîne cassée depuis le 18/09 y contribuait ; l'exécution du jour a remis de l'activité, sans garantie durable.

## 11. Ce qui reste à trancher

- **Mettre en œuvre D84** (newsletter = toujours un point, urgence faible), en trancher d'abord les deux sous-questions (un point par expéditeur ; alignement Gmail sur l'en-tête `List-Unsubscribe`) — premier chantier de la session suivante.
- **Vérifier la tenue de D88** : les credentials Google reconnectés le 26/09 au soir ne doivent plus expirer — contrôle simple après le 3 octobre 2026 (une exécution du workflow sans erreur de credential Google).
- **Keep-alive Supabase** : un appel quotidien planifié (n8n) pour éviter la mise en pause du free tier après 7 jours d'inactivité — tant que le Tour n'est pas déclenché automatiquement (D5).
- **Reposer la question D29 (repo public)** : des résumés de mails pro et perso arrivent désormais dans Supabase (`libelle`). Le repo ne contient que du code et des snapshots de workflow vérifiés sans données, mais la condition de réversibilité de D29 est formellement atteinte. Règle d'ici là : ne jamais épingler de données (`pinData`) dans n8n, elles partiraient dans les snapshots publics.
- **Événements Outlook « journée entière »** : stockés à minuit UTC, affichés 02:00 après conversion Paris et passant le filtre « aujourd'hui » la veille (constaté : « Mise à jour budgétaire !! » du 25/09 remonté le 26/09). Défaut antérieur, non traité.
- Mise en place concrète du workflow n8n annuel de récupération automatique des dates Parcoursup
- Suivi Présentiel/TT (D33) : rotation annuelle du board traitée en D43/D44 (config centralisée + rappel email) — reste la duplication/archivage manuels à faire chaque année, et le retraitement du jour du 22/09/2026 une fois le tournage réalisé. Déclenchement automatique du workflow principal (D5) toujours manuel.
- Migration n8n vers Oracle Cloud Free Tier (D30/D21) — toujours pertinente pour lever la dépendance au Mac Maison sur les workflows nécessitant Docker local
- Dette technique restante : le schéma Supabase initial (24 août — `points`, `tours`, `contexte_journee`) n'a jamais été versionné sur GitHub — à corriger à l'occasion, non bloquant (la colonne `confirme`, elle, est désormais versionnée — D39)
- Les 4 éléments reportés en D38 : checklist projets jour/semaine, candidature + lettre de motivation (template Canva), rappel des impératifs, sous-tâches via agents — aucun n'a de chantier dédié ni d'azimut d'accueil clair pour l'instant, à recadrer le moment venu.
- Fusion Google Calendar / Outlook (D16 + D45) : les deux sources devront être dédupliquées si un même événement apparaît dans les deux calendriers — règle de priorité ou de fusion pas encore définie.
- Seuils de volume (D15) et constantes de normalisation k (D26) à définir pour les 9 nouveaux azimuts — actuellement seuls Calendrier, Monday, Carrière, Management ont des valeurs actées
- **Chantier design du cercle à 15 azimuts (D53), suite** — portage et logo faits le 26/09 (10duodecies). Reste à faire : maquette du thème sombre (D81), désormais facilitée par les SVG `currentColor` ; retirer ou marquer comme archivée l'Option B (« labels rayonnants ») du canvas de design ; corriger dans ce même canvas le titre de l'artboard principal, resté « Option A — Anneau organique (Arrival) » alors qu'il porte la version Cercle + Point validée.
- Section 9 "Roadmap en itérations" à revisiter — elle décrit encore V1 comme "les 4 azimuts retenus", devenu inexact avec 15 azimuts actés (signalé par Cursor le 8 septembre 2026)
- Trouver une source automatique fiable pour l'azimut "Mémoire & connaissance" (D55) — condition d'activation, pas de saisie manuelle en attendant
- **Chantier dédié — enrichissement du lieu Outlook via Monday (D69, 19 septembre 2026) :** construire une requête Monday indépendante et isolée (pas de réutilisation de la branche Présentiel/TT filtrée sur `Absence`), avec `alwaysOutputData` à chaque étape, pour rapprocher par horaire les tournages du jour (colonne `LIEU`, id `label__1`) des événements Outlook sans lieu structuré. Prérequis déjà acquis : id de colonne confirmé, correctif de casse posé, défaut d'architecture du node "Détection tournage Martin (jour)" documenté (section 10septies). À construire un jour de semaine, avec de vraies données de test — sans quoi aucune validation fiable n'est possible (testé sans succès un samedi sans tournage ni réunion réels).
- Rate limit Monday GraphQL — filet de sécurité posé (D70, retry 4 tentatives/8s) mais non définitif : pas d'exploitation de l'en-tête `Retry-After`, pas de distinction erreur de quota vs erreur définitive. À revoir seulement si le problème réapparaît en usage réel (jusqu'ici rencontré uniquement en session de test, jamais en usage courant puisque Perimeter n'est pas encore en production quotidienne).

---

*Document vivant — à mettre à jour à chaque session de travail sur Perimeter.*
