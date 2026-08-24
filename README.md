# Perimeter

Outil personnel de gestion de charge mentale — projet de Martin Pavloff, distinct de la Tranquility Suite.

## Concept

Un cercle. Martin au centre. Chaque azimut représente une catégorie de préoccupation.
Plus les points non résolus s'accumulent, plus le trait s'épaissit — Perimeter parcourt
le cercle et propose des actions pour l'alléger.

## Architecture

- **Orchestration** : n8n (Oracle Cloud Free Tier)
- **Mémoire / état** : Supabase (Postgres + pgvector), Cloud managé
- **Intelligence IA** : Ollama / Mistral 7B, en local sur la machine active

## Documentation

Voir `docs/PERIMETER_DOCUMENT_FONDATEUR.md` pour le document de référence complet.

---

*Projet personnel — hors Tranquility Suite, hors Workflow Captif, hors Agence.*
