#!/bin/sh
set -eu
data="${XDG_DATA_HOME:-$HOME/.local/share}"
config="${XDG_CONFIG_HOME:-$HOME/.config}"
for dir in "$data/nautilus/scripts" "$data/nemo/scripts" "$config/caja/scripts"; do
	rm -f "$dir/Copy Absolute Path" "$dir/Copy Relative Path"
done
rm -f "$data/kio/servicemenus/pathfinder.desktop" "$data/kservices5/ServiceMenus/pathfinder.desktop" "$HOME/.local/bin/pathfinder"
echo "Pathfinder removed."
