#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# sync_workflow.sh — Synchronise un workflow n8n entre l'API locale et le repo
# Usage : ./sync_workflow.sh <workflow_id> pull|push
# ---------------------------------------------------------------------------

WORKFLOW_ID="${1:-}"
MODE="${2:-}"
API_BASE="http://localhost:5678/api/v1/workflows"
KEY_FILE="$HOME/.config/perimeter/n8n_api_key"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT_FILE="$REPO_DIR/${WORKFLOW_ID}.json"

# --- Validation des arguments -----------------------------------------------

if [[ -z "$WORKFLOW_ID" || -z "$MODE" ]]; then
  echo "Usage : $0 <workflow_id> pull|push" >&2
  exit 1
fi

if [[ "$MODE" != "pull" && "$MODE" != "push" ]]; then
  echo "Erreur : mode invalide '$MODE'. Utilise 'pull' ou 'push'." >&2
  exit 1
fi

# --- Lecture de la clé API --------------------------------------------------

if [[ ! -f "$KEY_FILE" ]]; then
  echo "Erreur : fichier de clé introuvable : $KEY_FILE" >&2
  echo "Crée-le avec : mkdir -p ~/.config/perimeter && echo 'ta_clé' > $KEY_FILE" >&2
  exit 1
fi

API_KEY="$(cat "$KEY_FILE" | tr -d '[:space:]')"

if [[ -z "$API_KEY" ]]; then
  echo "Erreur : $KEY_FILE est vide." >&2
  exit 1
fi

# --- Mode PULL --------------------------------------------------------------

if [[ "$MODE" == "pull" ]]; then
  echo "→ Pull du workflow '$WORKFLOW_ID' depuis $API_BASE/$WORKFLOW_ID …"

  HTTP_CODE=$(curl --silent --show-error --output "$OUT_FILE" \
    --write-out "%{http_code}" \
    --header "X-N8N-API-KEY: $API_KEY" \
    --header "Accept: application/json" \
    "$API_BASE/$WORKFLOW_ID")

  if [[ "$HTTP_CODE" != "200" ]]; then
    echo "Erreur : l'API a répondu HTTP $HTTP_CODE." >&2
    echo "Réponse :" >&2
    cat "$OUT_FILE" >&2
    rm -f "$OUT_FILE"
    exit 1
  fi

  echo "✓ Sauvegardé dans : $OUT_FILE"
  exit 0
fi

# --- Mode PUSH --------------------------------------------------------------

if [[ "$MODE" == "push" ]]; then
  if [[ ! -f "$OUT_FILE" ]]; then
    echo "Erreur : fichier source introuvable : $OUT_FILE" >&2
    echo "Lance d'abord : $0 $WORKFLOW_ID pull" >&2
    exit 1
  fi

  echo "→ Nettoyage du payload (suppression des clés refusées par l'API) …"

  PAYLOAD=$(python3 - "$OUT_FILE" <<'PYEOF'
import json, sys

ALLOWED_KEYS = {"name", "nodes", "connections", "settings"}

with open(sys.argv[1]) as f:
    wf = json.load(f)

cleaned = {k: v for k, v in wf.items() if k in ALLOWED_KEYS}
print(json.dumps(cleaned, ensure_ascii=False))
PYEOF
)

  echo "→ Push vers $API_BASE/$WORKFLOW_ID …"

  RESPONSE=$(curl --silent --show-error \
    --request PUT \
    --header "X-N8N-API-KEY: $API_KEY" \
    --header "Content-Type: application/json" \
    --header "Accept: application/json" \
    --data "$PAYLOAD" \
    "$API_BASE/$WORKFLOW_ID")

  HTTP_ERROR=$(echo "$RESPONSE" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    if 'message' in d and 'statusCode' in d:
        print(d.get('statusCode', '?'), '-', d.get('message', ''))
except:
    pass
")

  if [[ -n "$HTTP_ERROR" ]]; then
    echo "Erreur API : $HTTP_ERROR" >&2
    echo "Réponse complète :" >&2
    echo "$RESPONSE" >&2
    exit 1
  fi

  UPDATED_AT=$(echo "$RESPONSE" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    print(d.get('updatedAt', '(champ updatedAt absent de la réponse)'))
except Exception as e:
    print('(impossible de lire updatedAt :', e, ')')
")

  echo "✓ Workflow mis à jour. updatedAt : $UPDATED_AT"
  exit 0
fi
