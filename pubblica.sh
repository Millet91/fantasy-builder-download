#!/bin/bash
# Prepara l'APK per la pubblicazione come Release (10/11). Uso: ./pubblica.sh /percorso/the-caravan.apk 0.1.80
# Taglia l'APK in pezzi da 90 MB dentro release/ (GitHub non accetta file oltre 100 MB in un push), scrive versione
# e impronta. Poi: git add release && git commit --amend -m "APK <versione>" && git push --force-with-lease
# (--amend + force: così i pezzi vecchi non restano nella storia e il repo non cresce di 100 MB a ogni APK).
# Al push parte .github/workflows/pubblica-apk.yml, che ricompone l'APK e crea la Release.
set -euo pipefail
cd "$(dirname "$0")"
APK="$1"; VER="$2"
mkdir -p release
rm -f release/the-caravan.apk.part*
split -b 90m -d -a 2 "$APK" release/the-caravan.apk.part
echo "$VER" > release/version.txt
sha256sum "$APK" | cut -d' ' -f1 > release/sha256.txt
ls -la release
