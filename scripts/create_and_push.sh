#!/usr/bin/env bash
set -euo pipefail

# Script seguro para crear un repo en GitHub y empujar la rama main.
# Requiere GITHUB_TOKEN con scope 'repo'.
# Uso:
#   export GITHUB_TOKEN=ghp_... (tu token)
#   bash scripts/create_and_push.sh <owner> <repo> [public|private]

OWNER="$1"
REPO="$2"
VISIBILITY="${3:-public}"

if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "GITHUB_TOKEN no está seteado. Exporta GITHUB_TOKEN antes de ejecutar." >&2
  exit 1
fi

API_URL="https://api.github.com/user/repos"
# If owner is an organization, use orgs API
if [ "$OWNER" != "$(git config user.name)" ]; then
  API_URL="https://api.github.com/orgs/$OWNER/repos"
fi

declare -A DATA
DATA[name]="$REPO"
DATA[private]="false"
if [ "$VISIBILITY" = "private" ]; then
  DATA[private]="true"
fi

JSON_PAYLOAD="{\"name\": \"${REPO}\", \"private\": ${DATA[private]} }"

echo "Creando repo $OWNER/$REPO (visibility: $VISIBILITY) ..."

resp=$(curl -s -o /dev/stderr -w "%{http_code}" -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github+json" -d "$JSON_PAYLOAD" "$API_URL") || true

if [ "$resp" != "201" ]; then
  echo "Error creando repo. Código HTTP: $resp" >&2
  echo "Si el repo ya existe, puedes omitir la creación y sólo añadir remote y hacer push." >&2
fi

# Añadir remote y push
git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/${OWNER}/${REPO}.git"

echo "Haciendo push a origin/main ..."
git branch -M main
# Push with HTTPS; git preguntará por credenciales si no tienes credential helper
GIT_ASKPASS=$(mktemp)
cat > "$GIT_ASKPASS" <<'EOP'
#!/usr/bin/env bash
# Return token for git HTTPS auth
echo "$GITHUB_TOKEN"
EOP
chmod +x "$GIT_ASKPASS"
GIT_ASKPASS="$GIT_ASKPASS" GIT_TERMINAL_PROMPT=0 git push -u origin main || true
rm -f "$GIT_ASKPASS"

echo "Hecho. Si el push falló por autenticación, configura un Personal Access Token o usa SSH." 
