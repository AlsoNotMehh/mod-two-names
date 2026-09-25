<#
.SYNOPSIS
    AzerothCore mod-two-names: Client Wow.exe Patcher (PowerShell)
.DESCRIPTION
    Patches Wow.exe (3.3.5a build 12340):
    1. Patches ValidateName (offset 0x2B0390) so that spaces in character names
       (e.g. "John Doe") are accepted during character creation and sent to the server.
    2. Patches EditBox::InsertChar (offset 0x564F23) to unlock the 12-character keyboard
       typing limit so players can create longer names (e.g. "Illegal Immigrant").
.EXAMPLE
    .\patch_wow_exe.ps1 "C:\Path\To\World of Warcraft\Wow.exe"
#>

param(
    [string]$TargetFile = "Wow.exe"
)

if (-not (Test-Path $TargetFile)) {
    Write-Host "[Error] Target file '$TargetFile' not found." -ForegroundColor Red
    Write-Host "Usage: .\patch_wow_exe.ps1 <path-to-Wow.exe>" -ForegroundColor Yellow
    exit 1
}

$BackupFile = "$TargetFile.bak_two_names"
if (-not (Test-Path $BackupFile)) {
    Copy-Item $TargetFile $BackupFile
    Write-Host "[Backup] Created backup at '$BackupFile'" -ForegroundColor Cyan
}

$bytes = [System.IO.File]::ReadAllBytes($TargetFile)

# 1. Space support in ValidateName (Offset: 0x2B0390, VA: 0x006B0F90)
$valPatch = [byte[]](0xB8, 0x57, 0x00, 0x00, 0x00, 0xC3) # mov eax, 0x57; ret
[Array]::Copy($valPatch, 0, $bytes, 0x2B0390, $valPatch.Length)

# 2. Unlock character input length limit (Offset: 0x564F23, VA: 0x00965B23)
$lenPatch = [byte[]](0xE9, 0xF5, 0x00, 0x00, 0x00, 0x90) # jmp 0x965c1d; nop
[Array]::Copy($lenPatch, 0, $bytes, 0x564F23, $lenPatch.Length)

[System.IO.File]::WriteAllBytes($TargetFile, $bytes)
Write-Host "[Success] Successfully patched '$TargetFile' for dual names & expanded name length!" -ForegroundColor Green
