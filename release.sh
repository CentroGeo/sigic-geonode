#!/usr/bin/env bash
set -euo pipefail

RELEASE_BRANCH="4.4.x.sigic.whl"
BASE_TAG="v4.4.0-sigic"

BRANCH=$(git branch --show-current)
[ "$BRANCH" = "$RELEASE_BRANCH" ] || {
  echo "❌ Ejecuta desde $RELEASE_BRANCH"
  exit 1
}

# Árbol limpio
if ! git diff-index --quiet HEAD --; then
  echo "❌ Working tree sucio"
  exit 1
fi

# Calcular siguiente N
LAST_TAG=$(git tag --list "${BASE_TAG}.*" --sort=-v:refname | head -n1)

if [ -z "$LAST_TAG" ]; then
  N=1
else
  N="${LAST_TAG##*.}"
  N=$((N + 1))
fi

TAG="${BASE_TAG}.${N}"

echo "🚀 Nuevo release: $TAG"

# Commit marcador (opcional pero útil)
git commit --allow-empty -m "chore(release): $TAG"
git push origin "$RELEASE_BRANCH"

# Tag
git tag "$TAG"
git push origin "$TAG"

echo "✅ Tag creado: $TAG"
