#!/bin/bash

set -euo pipefail

OUT_FILE="${1:-hypr-remove-list.txt}"

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

paru -Qq | grep -i hypr | sort -u > "$tmp"

echo "Found hyprland packages:" >&2
echo < "$tmp" >&2
echo "" >&2

tmp_reverse="$(mktemp)"
while read -r pkg; do
  echo "=== Reverse deps for package $pkg ===" >&2
  pactree -r -u -l "$pkg" 2>/dev/null || true | tee -a "$tmp_reverse"
  echo "" >&2
done < "$tmp"

cat "$tmp" "$tmp_reverse" | sort -u > "$OUT_FILE"

mapfile -t pkgs < "$OUT_FILE"

if [[ "${#pkgs[@]}" -eq 0 ]]; then
  echo "No packages found in $OUT_FILE" >&2
  exit 0
fi

echo "Removing ${#pkgs[@]} packages:"
printf '  %s
'  "${pkgs[@]}"

read -rp "Proceed with removal? [y/N]: " ans
if [[ "$ans" != [yY] ]]; then
  echo "Aborted."
  exit 1
fi

paru -Rs "${pkgs[@]}"

echo "Finished removing packages." >&2

read -rp "Proceed with reinstallation? [y/N]: " ans
if [[ "$ans" != [yY] ]]; then
  echo "Aborted."
  exit 1
fi

paru -S "${pkgs[@]}"

echo "Finished installation of packages." >&2
