# PERIMETER — Protocole de démarrage de session

*Document vivant — repo `RealCoolclint/perimeter` = seule source de vérité.*
*Les ressources du projet Claude ne sont jamais considérées à jour pour Perimeter.*

---

## Obligatoire, dans cet ordre, avant toute discussion de fond

**1. Pull**
```bash
cd ~/Documents/GitHub/perimeter && git pull
```

**2. Identifier les documents les plus récents**
```bash
ls -v docs/PERIMETER_DOCUMENT_FONDATEUR_V*.md | tail -1 && ls docs/SESSION_TRAVAIL_*.md | sort | tail -1
```

**3. Lire le contenu réel**
```bash
cat docs/[fondateur trouvé] docs/[dernier récap trouvé]
```
JARVIS complète les noms de fichiers une fois le retour de la commande 2 reçu.

---

## Règle de versionnage associée

Le document fondateur est renommé à chaque mise à jour (jamais de contenu réécrit sous le même nom) :
```bash
git mv PERIMETER_DOCUMENT_FONDATEUR_V[ANCIEN].md PERIMETER_DOCUMENT_FONDATEUR_V[NOUVEAU].md
```

---

*Protocole permanent — Perimeter · 24 août 2026*


## Mise à jour — 24 août 2026, session ultérieure

Le repo est passé en **public** pour garantir l'accès direct de JARVIS via bash_tool
(clone Git standard, sans authentification). Le protocole devient automatique :
JARVIS exécute lui-même pull + identification + lecture en une seule séquence bash,
sans relais manuel de Martin.

**Condition de réversibilité actée avec Martin** : dès que Perimeter contient de la
donnée réelle sensible (tensions d'équipe nominatives, candidatures en cours, contenu
Supabase réel), la question du retour en privé doit être reposée.
