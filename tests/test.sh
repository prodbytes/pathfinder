#!/bin/sh
# Run: sh tests/test.sh
set -u
here=$(cd "$(dirname "$0")" && pwd)
pf="$here/../bin/pathfinder"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
fail=0

check() { # name expected actual
	if [ "$2" = "$3" ]; then echo "ok   $1"; else echo "FAIL $1: expected [$2] got [$3]"; fail=1; fi
}

mkdir -p "$tmp/home/repo/.git" "$tmp/home/repo/src/déjà vu" "$tmp/home/plain/sub" "$tmp/outside"
mkdir -p "$tmp/home/repo/vendor/inner"; : > "$tmp/home/repo/vendor/inner/.git"
touch "$tmp/home/repo/src/déjà vu/a&b \$x.txt" "$tmp/home/plain/sub/f.txt" "$tmp/outside/o.txt"
export HOME="$tmp/home"

check "absolute" "$tmp/home/repo/src/déjà vu/a&b \$x.txt" "$("$pf" absolute --print "$tmp/home/repo/src/déjà vu/a&b \$x.txt")"
check "relative in repo" "src/déjà vu/a&b \$x.txt" "$("$pf" relative --print "$tmp/home/repo/src/déjà vu/a&b \$x.txt")"
check "relative folder trailing slash" "src" "$("$pf" relative --print "$tmp/home/repo/src/")"
check "repo root itself falls back to home" "repo" "$("$pf" relative --print "$tmp/home/repo")"
check "submodule (.git file)" "x" "$(touch "$tmp/home/repo/vendor/inner/x"; "$pf" relative --print "$tmp/home/repo/vendor/inner/x")"
check "nested repo root relative to outer" "vendor/inner" "$("$pf" relative --print "$tmp/home/repo/vendor/inner")"
check "relative to home" "plain/sub/f.txt" "$("$pf" relative --print "$tmp/home/plain/sub/f.txt")"
check "outside home is absolute" "$tmp/outside/o.txt" "$("$pf" relative --print "$tmp/outside/o.txt")"
check "dot segments" "$tmp/outside/o.txt" "$("$pf" absolute --print "$tmp/./outside/./o.txt")"
check "relative input" "$tmp/outside/o.txt" "$(cd "$tmp" && "$pf" absolute --print outside/o.txt)"
check "multiple" "plain/sub/f.txt
src" "$("$pf" relative --print "$tmp/home/plain/sub/f.txt" "$tmp/home/repo/src")"
check "root" "/" "$("$pf" absolute --print /)"

if command -v pbcopy >/dev/null 2>&1; then
	old=$(pbpaste)
	env -i HOME="$HOME" PATH=/usr/bin:/bin "$pf" relative "$tmp/home/repo/src/déjà vu/a&b \$x.txt"
	check "clipboard, empty env, unicode" "src/déjà vu/a&b \$x.txt" "$(LC_ALL=en_US.UTF-8 pbpaste)"
	printf '%s' "$old" | pbcopy
fi

"$pf" bogus x 2>/dev/null; check "bad mode exits 2" 2 $?
exit $fail
