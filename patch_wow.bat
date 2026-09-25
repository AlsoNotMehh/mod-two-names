@echo off
setlocal

echo =======================================================
echo   AzerothCore mod-two-names: Client Wow.exe Patcher
echo =======================================================
echo.

set "TARGET=%~1"

if "%TARGET%"=="" (
    if exist "Wow.exe" (
        set "TARGET=Wow.exe"
    ) else (
        echo [!] Drag and drop your Wow.exe onto this .bat file, or
        echo     copy Wow.exe into this folder and run again.
        echo.
        set /p TARGET="Enter path to Wow.exe: "
    )
)

if not exist "%TARGET%" (
    echo [ERROR] File '%TARGET%' not found.
    pause
    exit /b 1
)

echo [*] Patching: %TARGET%
powershell -NoProfile -ExecutionPolicy Bypass -Command "$f='%TARGET%'; if (-not (Test-Path $f)) { exit 1 }; $bak=$f+'.bak_two_names'; if (-not (Test-Path $bak)) { Copy-Item $f $bak; Write-Host '[+] Backup created: '$bak -ForegroundColor Cyan }; $b=[System.IO.File]::ReadAllBytes($f); $p1=[byte[]](0xB8,0x57,0x00,0x00,0x00,0xC3); [Array]::Copy($p1,0,$b,0x2B0390,$p1.Length); $p2=[byte[]](0xE9,0xF5,0x00,0x00,0x00,0x90); [Array]::Copy($p2,0,$b,0x564F23,$p2.Length); [System.IO.File]::WriteAllBytes($f,$b); Write-Host '[SUCCESS] Wow.exe successfully patched for dual names and expanded name length!' -ForegroundColor Green"

if %ERRORLEVEL% equ 0 (
    echo.
    echo =======================================================
    echo   PATCH COMPLETE! You can now launch Wow.exe and enjoy
    echo   character creation with first and last names.
    echo =======================================================
) else (
    echo [ERROR] Patching failed.
)

echo.
pause
