#!/bin/bash
# ============================================================
# RESET — Restore placeholder page before demo
# Run:  cd pipeline && ./reset.sh
# ============================================================

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "Restoring placeholder page..."
cd "$REPO_ROOT"

# Restore index.html to repo version (placeholder)
git checkout main -- site/index.html

# Remove uploaded photos
rm -f site/photos/photo-*.jpg site/photos/photo-*.jpeg site/photos/photo-*.png site/photos/photo-*.webp

# Remove page-content.json
rm -f pipeline/page-content.json

# Push
git add site/
git commit -m "Reset: placeholder page before demo" 2>/dev/null
git push 2>/dev/null

echo "Page restored to placeholder. Ready for next demo."
