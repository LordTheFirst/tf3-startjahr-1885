# External Windows tool. Do not include this script in a ModHub upload.
[CmdletBinding()]
param(
    [ValidateSet('inspect', 'apply', 'restore')]
    [string]$Mode = 'inspect',
    [string]$GamePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-Hash([string]$Path) {
    $stream = [IO.File]::OpenRead($Path)
    $algorithm = [Security.Cryptography.SHA256]::Create()
    try {
        return [BitConverter]::ToString($algorithm.ComputeHash($stream)).Replace('-', '').ToLowerInvariant()
    } finally {
        $stream.Dispose()
        $algorithm.Dispose()
    }
}

function Set-PatchBytes([string]$Path, [object]$Plan, [bool]$Reverse) {
    $stream = [IO.File]::Open($Path, [IO.FileMode]::Open, [IO.FileAccess]::ReadWrite, [IO.FileShare]::None)
    try {
        foreach ($edit in $Plan.edits) {
            $beforeHex = if ($Reverse) { [string]$edit.after } else { [string]$edit.before }
            $afterHex = if ($Reverse) { [string]$edit.before } else { [string]$edit.after }
            if ($beforeHex.Length -ne $afterHex.Length -or ($beforeHex.Length % 2) -ne 0) {
                throw 'Invalid patch byte lengths.'
            }
            $count = [int]($beforeHex.Length / 2)
            if ([long]$edit.offset -lt 0 -or [long]$edit.offset + $count -gt $stream.Length) {
                throw 'Patch offset outside archive.'
            }
            $before = New-Object byte[] $count
            $after = New-Object byte[] $count
            for ($i = 0; $i -lt $count; $i++) {
                $before[$i] = [Convert]::ToByte($beforeHex.Substring(2 * $i, 2), 16)
                $after[$i] = [Convert]::ToByte($afterHex.Substring(2 * $i, 2), 16)
            }
            $buffer = New-Object byte[] $count
            $stream.Position = [long]$edit.offset
            if ($stream.Read($buffer, 0, $count) -ne $count) { throw 'Incomplete archive read.' }
            for ($i = 0; $i -lt $count; $i++) {
                if ($buffer[$i] -ne $before[$i]) { throw 'Unexpected archive bytes.' }
            }
            $stream.Position = [long]$edit.offset
            $stream.Write($after, 0, $count)
        }
        $stream.Flush($true)
    } finally {
        $stream.Dispose()
    }
}

function Invoke-MenuPatch([string]$InstallPath, [string]$Action, [object]$Plan) {
    # Resolve the explicitly selected installation. No directory searching or deleting.
    $resolvedGame = (Resolve-Path -LiteralPath $InstallPath).ProviderPath
    $archive = Join-Path $resolvedGame 'base\content\gui.zip'
    $manifest = Join-Path $resolvedGame 'base\_content.json'
    if (-not (Test-Path -LiteralPath $archive -PathType Leaf) -or
        -not (Test-Path -LiteralPath $manifest -PathType Leaf)) { throw 'Not a Transport Fever 3 installation folder.' }
    if ((Get-Hash $manifest) -ne $Plan.manifest_sha256) {
        throw 'Unsupported game content index, possibly a game update. Nothing changed.'
    }
    if ((Get-Item -LiteralPath $archive).Length -ne [long]$Plan.archive_size) {
        throw 'Unsupported archive size. Nothing changed.'
    }
    $current = Get-Hash $archive
    if ($current -ne $Plan.original_sha256 -and $current -ne $Plan.patched_sha256) {
        throw 'Unsupported or modified gui.zip. Nothing changed.'
    }
    $state = if ($current -eq $Plan.patched_sha256) { '1885 menu active' } else { 'Original 1900 menu active' }
    Write-Output $state
    if ($Action -eq 'inspect') { return }

    # Get-Process avoids localized console-output encoding problems.
    $processes = @(Get-Process -ErrorAction Stop | Where-Object { $_.ProcessName -ieq 'TransportFever3' })
    if ($processes.Count -gt 0) { throw 'Close Transport Fever 3 completely before applying/restoring.' }
    $desired = if ($Action -eq 'restore') { $Plan.original_sha256 } else { $Plan.patched_sha256 }
    if ($current -eq $desired) { Write-Output 'Already in requested state. Nothing changed.'; return }

    $backup = Join-Path (Split-Path -Parent $archive) ('gui.1885-original-' + $Plan.original_sha256.Substring(0,12) + '.bak')
    $stage = Join-Path (Split-Path -Parent $archive) 'gui.1885-patch.tmp'
    if (Test-Path -LiteralPath $stage) { throw "Temporary file already exists; inspect before retrying: $stage" }
    if (Test-Path -LiteralPath $backup) {
        if ((Get-Hash $backup) -ne $Plan.original_sha256) { throw 'Existing original backup is invalid; refusing to overwrite it.' }
    } else {
        # A verified patched archive can be reversed into the byte-identical original backup.
        [IO.File]::Copy($archive, $stage, $false)
        if ($current -eq $Plan.patched_sha256) { Set-PatchBytes $stage $Plan $true }
        if ((Get-Hash $stage) -ne $Plan.original_sha256) { throw "Backup verification failed. Temporary file retained: $stage" }
        [IO.File]::Move($stage, $backup)
    }

    if ($Action -eq 'restore') {
        [IO.File]::Copy($backup, $stage, $false)
    } else {
        [IO.File]::Copy($archive, $stage, $false)
        Set-PatchBytes $stage $Plan $false
    }
    if ((Get-Hash $stage) -ne $desired) { throw "Prepared archive verification failed. Temporary file retained: $stage" }
    # Refuse a concurrent game update or newly launched game before the atomic replacement.
    if ((Get-Hash $archive) -ne $current -or (Get-Hash $manifest) -ne $Plan.manifest_sha256) {
        throw "Game files changed during preparation. Temporary file retained: $stage"
    }
    $processes = @(Get-Process -ErrorAction Stop | Where-Object { $_.ProcessName -ieq 'TransportFever3' })
    if ($processes.Count -gt 0) { throw "Game was started during preparation. Close it; temporary file retained: $stage" }
    [IO.File]::Replace($stage, $archive, [NullString]::Value)
    if ((Get-Hash $archive) -ne $desired) { throw "Final verification failed. Original backup: $backup" }
    Write-Output $(if ($Action -eq 'restore') { 'Original 1900 menu restored.' } else { '1885 menu applied. Install/enable the companion mod and start a new game at 1885.' })
    Write-Output "Original backup: $backup"
}

if ($MyInvocation.InvocationName -ne '.') {
    try {
        if ([string]::IsNullOrWhiteSpace($GamePath)) {
            $GamePath = (Read-Host 'Transport Fever 3 installation folder (not userdata)').Trim('"')
        }
        $planPath = Join-Path $PSScriptRoot 'patch.json'
        $plan = Get-Content -LiteralPath $planPath -Raw -Encoding UTF8 | ConvertFrom-Json
        Invoke-MenuPatch $GamePath $Mode $plan
    } catch {
        Write-Error $_
        exit 1
    }
}
