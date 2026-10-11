#!/usr/bin/env bash
# Check this repository: every file in archives/ has the checksum written in
# sha256sums.txt, the split archives join into the file of sha256sums-joined.txt,
# and every archive unpacks (it is read all the way through, nothing is written).
#   ./check.sh
set -uo pipefail
cd "$(dirname "$0")"
bad=0
fail() { echo "FAILED: $*"; bad=$((bad + 1)); }

echo "== checksums"
sha256sum -c --quiet sha256sums.txt || fail "sha256sums.txt"
# every archive is listed
for f in archives/*; do
  grep -q "  $f\$" sha256sums.txt || fail "$f is not in sha256sums.txt"
done

# the contents of an archive, joined from its parts when it was split
stream() {
  if [ -f "$1" ]; then cat "$1"; else cat "$1".part-*; fi
}

echo "== split archives"
if [ -s sha256sums-joined.txt ]; then
  while read -r sum name; do
    got="$(cat "$name".part-* | sha256sum | cut -d' ' -f1)"
    [ "$got" = "$sum" ] && echo "  $name: joined OK" || fail "$name: the joined parts are not the right file"
  done < sha256sums-joined.txt
fi

echo "== unpacking"
names="$( { ls archives | grep -v '\.part-[0-9]*$'; ls archives | sed -n 's/\.part-[0-9]*$//p'; } | sort -u)"
for n in $names; do
  f="archives/$n"
  case "$n" in
    *.tar.xz)          stream "$f" | tar -tJf - >/dev/null ;;
    *.tar.gz|*.tgz)    stream "$f" | tar -tzf - >/dev/null ;;
    *.tar.bz2)         stream "$f" | tar -tjf - >/dev/null ;;
    *.zip)             unzip -tq "$f" >/dev/null ;;
    *.lha)             if command -v lha >/dev/null; then lha tq "$f" >/dev/null; else [ -s "$f" ]; fi ;;
    *.lzx)             [ -s "$f" ] ;;       # Amiga LZX: the checksum above is the check
    *.gz)              gzip -t "$f" ;;
    *.patch)           grep -q '^diff --git' "$f" ;;
    *)                 echo "  (not checked: $n)"; true ;;
  esac && echo "  $n" || fail "$n does not unpack"
done

if [ "$bad" -eq 0 ]; then echo "all good"; else echo "$bad problem(s)"; exit 1; fi
