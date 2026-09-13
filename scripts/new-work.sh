#!/usr/bin/env bash
# 新しい実験用ページを scaffold する
# 使い方: scripts/new-work.sh "作品名"

set -euo pipefail

TITLE="${1:-}"
if [ -z "$TITLE" ]; then
  echo "使い方: scripts/new-work.sh \"作品名\""
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')
DATE=$(date +%Y-%m)
DIR="$ROOT/works/${DATE}-${SLUG}"

if [ -d "$DIR" ]; then
  echo "すでに存在します: $DIR"
  exit 1
fi

mkdir -p "$DIR"
sed "s/{{TITLE}}/${TITLE}/g" "$ROOT/templates/experiment/index.html" > "$DIR/index.html"
cp "$ROOT/templates/experiment/style.css" "$DIR/style.css"

echo "作成しました: works/${DATE}-${SLUG}/"
echo ""
echo "works.html の <div class=\"gallery\"> 内に、下記を追記してください:"
echo ""
cat <<SNIPPET
      <a class="work" href="works/${DATE}-${SLUG}/index.html">
        <span class="frame"><iframe src="works/${DATE}-${SLUG}/index.html" loading="lazy" tabindex="-1"></iframe></span>
        <span class="meta">
          <span class="work-title">${TITLE}</span>
          <span class="work-date">${DATE}</span>
        </span>
      </a>
SNIPPET
