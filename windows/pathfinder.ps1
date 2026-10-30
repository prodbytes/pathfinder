# pathfinder: copy the absolute or relative path of files to the clipboard.
# Usage: pathfinder.ps1 absolute|relative PATH...
# Relative paths are relative to the enclosing Git repository root,
# else to your user profile folder, else the absolute path is used.
param(
    [Parameter(Mandatory = $true, Position = 0)][ValidateSet('absolute', 'relative')][string]$Mode,
    [Parameter(Mandatory = $true, Position = 1, ValueFromRemainingArguments = $true)][string[]]$Paths
)

function Get-RepoRoot([string]$Path) {
    $dir = Split-Path -Parent $Path
    while ($dir) {
        if (Test-Path -LiteralPath (Join-Path $dir '.git')) { return $dir }
        $parent = Split-Path -Parent $dir
        if ($parent -eq $dir) { break }
        $dir = $parent
    }
    return $null
}

function Get-Relative([string]$Path) {
    $root = Get-RepoRoot $Path
    if (-not $root) {
        $userHome = $env:USERPROFILE.TrimEnd('\')
        if ($Path.StartsWith($userHome + '\', [StringComparison]::OrdinalIgnoreCase)) { $root = $userHome }
    }
    if (-not $root) { return $Path }
    return $Path.Substring($root.TrimEnd('\').Length + 1)
}

$out = foreach ($p in $Paths) {
    $full = [System.IO.Path]::GetFullPath($p)
    if ($full.Length -gt 3) { $full = $full.TrimEnd('\') }
    if ($Mode -eq 'relative') { Get-Relative $full } else { $full }
}
Set-Clipboard -Value ($out -join "`r`n")
