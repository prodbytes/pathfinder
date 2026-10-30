foreach ($target in '*', 'Directory') {
    foreach ($mode in 'Absolute', 'Relative') {
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "HKCU:\Software\Classes\$target\shell\PathfinderCopy$mode"
    }
}
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue (Join-Path $env:LOCALAPPDATA 'Pathfinder')
Write-Host 'Pathfinder removed.'
