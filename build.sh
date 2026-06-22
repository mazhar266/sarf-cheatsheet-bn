#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST_DIR="$PROJECT_ROOT/dist"

cd "$PROJECT_ROOT"
mkdir -p "$DIST_DIR"

xelatex -interaction=nonstopmode -halt-on-error -output-directory="$DIST_DIR" main.tex

echo "PDF written to $DIST_DIR/main.pdf"
