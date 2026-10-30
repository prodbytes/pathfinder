#!/bin/sh
# Install Pathfinder context-menu entries for Linux file managers:
# Nautilus (GNOME Files), Nemo, Caja and Dolphin.
# Needs a clipboard tool: wl-clipboard (Wayland), xclip or xsel (X11).
set -eu

here=$(cd "$(dirname "$0")" && pwd)
bin="$HOME/.local/bin/pathfinder"
data="${XDG_DATA_HOME:-$HOME/.local/share}"
config="${XDG_CONFIG_HOME:-$HOME/.config}"

mkdir -p "$(dirname "$bin")"
cp "$here/../bin/pathfinder" "$bin"
chmod 755 "$bin"
echo "Installed: $bin"

# Nautilus, Nemo and Caja run executable files in their scripts folder,
# passing the selected files as arguments. The folder is only created
# when the file manager is present.
for dir in "$data/nautilus/scripts" "$data/nemo/scripts" "$config/caja/scripts"; do
	parent=$(dirname "$dir")
	[ -d "$parent" ] || command -v "$(basename "$parent")" >/dev/null 2>&1 || continue
	mkdir -p "$dir"
	for mode in Absolute Relative; do
		lower=$(echo "$mode" | tr 'A-Z' 'a-z')
		printf '#!/bin/sh\nexec "%s" %s "$@"\n' "$bin" "$lower" > "$dir/Copy $mode Path"
		chmod 755 "$dir/Copy $mode Path"
	done
	echo "Installed scripts in: $dir"
done

# Dolphin service menu (KDE 6 path, plus KDE 5 for older systems).
if command -v dolphin >/dev/null 2>&1; then
	for dir in "$data/kio/servicemenus" "$data/kservices5/ServiceMenus"; do
		mkdir -p "$dir"
		cat > "$dir/pathfinder.desktop" <<DESKTOP
[Desktop Entry]
Type=Service
MimeType=all/all;
Actions=copyAbsolute;copyRelative;
X-KDE-ServiceTypes=KonqPopupMenu/Plugin
X-KDE-Priority=TopLevel

[Desktop Action copyAbsolute]
Name=Copy Absolute Path
Icon=edit-copy
Exec="$bin" absolute %F

[Desktop Action copyRelative]
Name=Copy Relative Path
Icon=edit-copy
Exec="$bin" relative %F
DESKTOP
		chmod 755 "$dir/pathfinder.desktop"
		echo "Installed Dolphin service menu: $dir/pathfinder.desktop"
	done
fi

if ! command -v wl-copy >/dev/null 2>&1 && ! command -v xclip >/dev/null 2>&1 && ! command -v xsel >/dev/null 2>&1; then
	echo "Warning: install wl-clipboard, xclip or xsel so paths can reach the clipboard." >&2
fi
echo "Done. Nautilus/Nemo/Caja: right-click > Scripts. Dolphin: right-click menu."
