#!/bin/sh
set -eu
rm -rf "$HOME/Library/Services/Copy Absolute Path.workflow" \
       "$HOME/Library/Services/Copy Relative Path.workflow" \
       "$HOME/Library/Application Support/Pathfinder"
/System/Library/CoreServices/pbs -flush >/dev/null 2>&1 || true
/System/Library/CoreServices/pbs -update >/dev/null 2>&1 || true
echo "Pathfinder removed."
