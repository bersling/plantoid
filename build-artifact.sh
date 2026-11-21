#!/bin/sh
# Turns index.html into the page fragment the claude.ai Artifact host expects
# (no doctype/html/head/body; the host adds its own skeleton with charset + viewport).
set -e
cd "$(dirname "$0")"
mkdir -p dist
sed -e '/^<!doctype html>$/d' -e '/^<html lang="en">$/d' -e '/^<\/html>$/d' \
    -e '/^<head>$/d' -e '/^<\/head>$/d' -e '/^<body>$/d' -e '/^<\/body>$/d' \
    -e '/^<meta charset="utf-8">$/d' -e '/^<meta name="viewport"/d' \
    index.html > dist/plantoid.html
echo "wrote dist/plantoid.html"
