# PERIMETER — Veille Outils Open Source

*Document vivant — mis à jour au fil des sessions de travail sur Perimeter*
*Version 1.1 — 25 août 2026 (retrouvé après perte lors du passage en ressources projet, statuts mis à jour)*

---

## Comment lire ce document

Chaque outil est classé par statut :
- 🟢 **Retenu** — décision actée, dans l'architecture
- 🟡 **À évaluer** — identifié, pas encore testé ni tranché
- ⚪ **À surveiller** — repéré pour plus tard, pas encore prioritaire

---

## Orchestration & automatisation

| Outil | Statut | Note |
|---|---|---|
| **n8n** | 🟢 Retenu | Colonne vertébrale de Perimeter. Self-hosted gratuit, 1800+ connecteurs, nœuds IA natifs compatibles Ollama, coffre-fort d'identifiants chiffré intégré. Dev/validation en local Docker d'abord, migration Oracle Cloud une fois la logique métier stable (**D30**). |
| **Node-RED** | ⚪ À surveiller | Alternative plus légère à n8n, moins riche en connecteurs. À garder en tête si n8n s'avère trop lourd à héberger. |
| **Huginn** | ⚪ À surveiller | Outil historique de veille/agents autonomes, plus ancien, communauté plus réduite. |
| **Activepieces** | ⚪ À surveiller | Concurrent direct de n8n, licence plus permissive sur certains points, écosystème plus jeune. |

---

## Intelligence artificielle locale

| Outil | Statut | Note |
|---|---|---|
| **Ollama** | 🟢 Retenu | Moteur d'exécution des modèles IA en local, gratuit, illimité. En local sur le Mac utilisé au moment du tour. |
| **Mistral 7B** | 🟢 Retenu (**D22**, 23 août) | Meilleur choix pour le français, licence Apache 2.0. Confirmé pour le Mac Maison (16 Go) — tient confortablement avec marge pour le reste du système. |
| **gpt-oss:20b** | 🟡 À évaluer | Bon polyvalent si le Mac dispose d'au moins 16 Go de RAM. Reste une option de secours si Mistral montre ses limites sur un usage précis. |
| **Qwen 3.6** | ⚪ À surveiller | Très bon en multilingue et agents outillés, à comparer à Mistral sur le français pur. |
| **Whisper** | 🟢 Retenu (déjà utilisé côté Tranquility) | Transcription audio, réutilisable si Perimeter intègre un jour de la voix. |
| **Piper** | ⚪ À surveiller | Synthèse vocale légère et open source, utile si brief audio du matin envisagé. |

---

## Données & mémoire

| Outil | Statut | Note |
|---|---|---|
| **Supabase** | 🟢 Retenu (**D21**) | Postgres hébergé, palier gratuit généreux, extension pgvector intégrée pour la recherche sémantique. Cloud managé — pas de self-hosting, pour sortir la donnée la plus sensible du même risque que l'instance Oracle. |
| **Qdrant** | ⚪ À surveiller | Base vectorielle dédiée, à envisager seulement si pgvector devient limitant à l'usage. |
| **Chroma** | ⚪ À surveiller | Alternative légère à Qdrant, plus simple à héberger en solo. |

---

## Sources & agrégation

| Outil | Statut | Note |
|---|---|---|
| **FreshRSS** | 🟡 À évaluer | Lecteur RSS auto-hébergé, léger, pour centraliser la revue de presse avant traitement IA. |
| **Miniflux** | 🟡 À évaluer | Alternative à FreshRSS, plus minimaliste. |
| **RSS-Bridge** | ⚪ À surveiller | Transforme certaines pages sans flux RSS officiel en flux exploitables. Utile mais à manier avec prudence sur les réseaux sociaux (zone grise côté conditions d'utilisation). |
| **France Travail API** | 🟢 Retenu | Officielle, gratuite, 300 000+ offres structurées. |

---

## Automatisation navigateur

| Outil | Statut | Note |
|---|---|---|
| **Playwright** | 🟡 À évaluer | Pour les zones bloquées côté API (lecture LinkedIn) — piloté par Martin, pas en automatique permanent. |

---

## Interface & visualisation

| Outil | Statut | Note |
|---|---|---|
| **Homepage** | ⚪ À surveiller | Dashboard open source auto-hébergé — dépassé maintenant que le cercle est retenu comme interface centrale (**D24**). |
| **Dashy** | ⚪ À surveiller | Même famille que Homepage. |
| **D3.js** | 🟡 À évaluer | Bibliothèque de référence pour construire une visualisation circulaire dynamique et animée — candidat naturel pour le cercle de charge. |
| **Nivo** | ⚪ À surveiller | Bibliothèque de graphiques basée sur D3, plus simple à intégrer en React, à comparer pour le rendu du cercle. |

---

## Hébergement

| Outil | Statut | Note |
|---|---|---|
| **Oracle Cloud Free Tier** | 🟢 Retenu (**D21**) | Machine virtuelle gratuite, disponible 24h/24 pour héberger n8n. Allocation réduite depuis juin 2026 (2 OCPU / 12 Go, contre 4/24 avant) — reste utilisable pour n8n (léger) mais surveillé de près. Migration prévue une fois la logique n8n validée en local (**D30**). |
| **Render (+ astuce anti-veille)** | ⚪ À surveiller | Alternative plus simple à configurer mais qui s'endort après 15 minutes d'inactivité — nécessite un ping régulier pour rester réactif. |

---

## Prochaines pistes de veille (non explorées)

- Bibliothèques légères de calcul de score / pondération (pour la formule de charge par azimut)
- Outils open source de détection d'anomalies sur des séries temporelles (utile pour les alertes d'audience Insta/TikTok/YouTube)
- Solutions open source de génération de lettres de motivation à partir d'un template

---

## Process de veille — pour la suite

Contrairement à la Tranquility Suite (flotte de 23 outils, veille à 4 niveaux de lecture documentée dans `TRANQUILITY_VEILLE_OUTILS.md`), Perimeter est un projet personnel à échelle plus restreinte. Le process est donc allégé, calqué sur le modèle éprouvé de `TRANQUILITY_VEILLE_IA.md` mais réduit à deux niveaux :

### Niveau 1 — Ajout à la volée (permanent)
Dès qu'un outil open source pertinent est repéré (recherche perso, recommandation, veille TikTok/web), il est ajouté directement dans la table concernée avec le statut ⚪ **À surveiller**. Pas besoin d'attendre une session dédiée — ce document s'enrichit en continu.

### Niveau 2 — Revue à la demande
Déclencheur : Martin dit *"revue veille Perimeter"*. JARVIS relit ce document, vérifie si un outil ⚪ ou 🟡 mérite de passer au statut supérieur (test, ou décision actée avec un nouveau D-number dans le doc fondateur), et signale si une piste devient obsolète (ex. Homepage/Dashy après D24).

**Règle d'intégration — avant de faire passer un outil de 🟡 à 🟢 :**
1. Gratuit ou palier gratuit suffisant pour un usage personnel
2. Auto-hébergeable ou cloud managé à coût nul (cohérent avec la contrainte "coût quasi nul" du projet)
3. Apporte une valeur mesurable sur un azimut réellement construit — pas une pré-optimisation

---

*Document vivant — à enrichir à chaque nouvelle découverte, sans attendre une session dédiée.*
