# Session de travail — 24 août 2026
## Perimeter — protocole de démarrage de session, versionnage, gouvernance documentaire

*Session courte — mise en place de garde-fous méthodologiques, aucun contenu produit sur le fond de Perimeter*

---

## Chantiers traités

### Détection d'un écart entre le repo GitHub et les ressources du projet Claude
En reprenant la session avec un prompt de continuation annonçant des décisions D24 à D28 et une v1.3 du document fondateur, aucune trace de ces éléments n'a été trouvée dans les ressources du projet Claude (qui s'arrêtaient à la v1.2, D22). Vérification via `git pull` + exploration du repo local (`ls`, `find`, `cat`) : le repo `RealCoolclint/perimeter` contenait bien la session "Design du cercle" du 24 août et le document fondateur v1.3 à jour, dans un sous-dossier `docs/` non répliqué dans les ressources du projet Claude.

### Versionnage des documents fondateurs
Constat que `PERIMETER_DOCUMENT_FONDATEUR.md` n'avait pas de numéro de version dans son nom de fichier, contrairement à la convention Tranquility (`TRANQUILITY_PLAN_DIRECTEUR_V5_90.md`). Décision d'aligner Perimeter sur la même convention, avec renommage à chaque mise à jour (`git mv`, jamais de réécriture sous le même nom).

### Protocole de démarrage de session
Mise en place d'un protocole terminal systématique (pull → identification des documents les plus récents par tri → lecture du contenu réel) pour garantir que chaque session Perimeter démarre sur la vérité du repo GitHub, jamais sur les ressources du projet Claude (jugées non fiables pour ce projet, faute de synchronisation automatique).

### Intégration au skill context-loader
Ajout d'un mécanisme générique de "source de vérité externe déclarée" dans le skill `context-loader`, avec Perimeter comme premier exemple. Rend le déclenchement du protocole automatique et indépendant du projet Claude actif — le skill sait reconnaître Perimeter dans n'importe quelle conversation.

---

## Décisions actées

- Le repo `RealCoolclint/perimeter` (privé) est la seule source de vérité pour Perimeter — les ressources du projet Claude ne sont jamais considérées à jour et servent au mieux de filet de secours signalé comme tel.
- Le document fondateur de Perimeter est renommé à chaque mise à jour de version (`git mv`, jamais de contenu réécrit sous le même nom) — convention alignée sur Tranquility.
- Protocole de démarrage de session Perimeter formalisé et versionné : `docs/PERIMETER_PROTOCOLE_DEMARRAGE_SESSION.md` sur le repo.
- Le skill `context-loader` gère désormais une liste de "sources de vérité externes" par projet — ajout d'un nouveau projet à cette liste se fait uniquement sur demande explicite de Martin, jamais par déduction automatique.

---

## Livrables produits

| Fichier / Élément | Nature | État |
|-------------------|--------|------|
| `docs/PERIMETER_DOCUMENT_FONDATEUR_V1_3.md` | Renommage (contenu inchangé) | ✅ pushé |
| `docs/PERIMETER_PROTOCOLE_DEMARRAGE_SESSION.md` | Nouveau document | ✅ pushé |
| `context-loader/SKILL.md` — section "Mode A-bis" | Skill mis à jour | ✅ (confirmé par Martin) |
| Paragraphe "Règle permanente — Protocole de démarrage Perimeter" | Proposé pour les Instructions du projet Claude (filet de sécurité, non obligatoire) | 🟡 en attente |

---

## Commandes Terminal produites

```bash
# Renommage versionné du document fondateur
cd ~/Documents/GitHub/perimeter/docs && git mv PERIMETER_DOCUMENT_FONDATEUR.md PERIMETER_DOCUMENT_FONDATEUR_V1_3.md
```

```bash
# Commit + push des deux changements
cd ~/Documents/GitHub/perimeter && git commit -m "Ajout protocole de démarrage de session + versionnage document fondateur (v1.3)" && git push
```

---

## Pièges découverts

- Les ressources d'un projet Claude ne se synchronisent jamais automatiquement avec un repo GitHub associé → pour tout projet où le repo est la vraie source de vérité, ne jamais faire confiance aux ressources du projet Claude sans vérification terminal explicite en début de session.
- Un document fondateur sans version dans son nom de fichier rend impossible de détecter un décalage juste en listant les fichiers → toujours versionner dans le nom, pas seulement dans l'en-tête du contenu.

---

## Prochaines étapes

1. Coller le paragraphe "Règle permanente — Protocole de démarrage Perimeter" dans les Instructions du projet Claude (filet de sécurité, optionnel vu que le skill `context-loader` fait déjà le travail)
2. Reconstituer ou retrouver `PERIMETER_VEILLE_OPENSOURCE.md`
3. Mise en place du workflow n8n annuel de récupération automatique des dates Parcoursup
4. Première implémentation : schéma Supabase, premiers workflows n8n, premier azimut construit de bout en bout

---

*Session 24 août 2026 · Perimeter · Mac Maison (martinpavloff)*
