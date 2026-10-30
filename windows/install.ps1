# Adds "Copy Absolute Path" and "Copy Relative Path" to the Explorer
# right-click menu for files and folders (current user, no admin needed).
# On Windows 11 they appear under "Show more options" (Shift+F10).
$ErrorActionPreference = 'Stop'
$dest = Join-Path $env:LOCALAPPDATA 'Pathfinder'
New-Item -ItemType Directory -Force -Path $dest | Out-Null
Copy-Item -Force (Join-Path $PSScriptRoot 'pathfinder.ps1') $dest
$script = Join-Path $dest 'pathfinder.ps1'

foreach ($target in '*', 'Directory') {
    foreach ($mode in 'Absolute', 'Relative') {
        $key = "HKCU:\Software\Classes\$target\shell\PathfinderCopy$mode"
        New-Item -Force -Path $key | Out-Null
        Set-ItemProperty -Path $key -Name '(Default)' -Value "Copy $mode Path"
        Set-ItemProperty -Path $key -Name 'Icon' -Value 'imageres.dll,-5302'
        New-Item -Force -Path "$key\command" | Out-Null
        $cmd = "powershell.exe -NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$script`" $($mode.ToLower()) `"%1`""
        Set-ItemProperty -Path "$key\command" -Name '(Default)' -Value $cmd
    }
}
Write-Host 'Done. Right-click a file or folder in Explorer.'
