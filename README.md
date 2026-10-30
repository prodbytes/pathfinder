# pathfinder

Adds **Copy Absolute Path** and **Copy Relative Path** to the right-click
menu of your file manager.

| OS | Where it shows up |
|----|-------------------|
| macOS | Finder right-click > Quick Actions (or the bottom of the menu) |
| Linux | Nautilus, Nemo, Caja: right-click > Scripts. Dolphin: right-click menu |
| Windows | Explorer right-click (Windows 11: "Show more options") |

## What gets copied

- **Absolute path**: the full path, e.g. `/Users/me/src/app/lib/util.js`.
- **Relative path**: relative to the root of the Git repository that contains
  the item, e.g. `lib/util.js`. Outside a repository it is relative to your
  home folder. Outside your home folder the absolute path is copied.

Selecting several items copies one path per line.

## Install

macOS (no Xcode, no admin rights):

```sh
sh macos/install.sh
```

Linux (needs `wl-clipboard`, `xclip` or `xsel`):

```sh
sh linux/install.sh
```

Windows (PowerShell):

```powershell
powershell -ExecutionPolicy Bypass -File windows\install.ps1
```

Each folder has a matching `uninstall` script.

## Command line

The core is a POSIX shell script you can also use directly:

```sh
bin/pathfinder relative path/to/file          # copies to clipboard
bin/pathfinder absolute --print a.txt b.txt   # prints instead
```

## How it works

- **macOS** installs two Automator Quick Actions in `~/Library/Services` that
  call the script, which is copied to `~/Library/Application Support/Pathfinder`.
- **Linux** installs file-manager scripts and a Dolphin service menu that call
  `~/.local/bin/pathfinder`.
- **Windows** registers per-user Explorer verbs that run `pathfinder.ps1`.
  Explorer runs the verb once per selected item, so with several items
  selected only the last path stays on the clipboard.

## Tests

```sh
sh tests/test.sh
```
