@echo off
title Gaming Optimizer - Restore Original Settings
color 0C
echo.
echo =====================================================
echo        VRAĆANJE ORIGINALNIH POSTAVKI
echo =====================================================
echo.
echo Ovaj fajl će vratiti originalne postavke sistema.
echo Pritisnite bilo koji taster da nastavite...
pause >nul

REM Check for admin privileges
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo GREŠKA: Morate pokrenuti kao Administrator!
    pause
    exit /b
)

echo.
echo Vraćanje DNS postavki na automatske...
netsh interface ip set dns "Wi-Fi" dhcp >nul 2>&1
netsh interface ip set dns "Ethernet" dhcp >nul 2>&1
echo ✓ DNS postavke vraćene

echo.
echo Vraćanje power plan-a na Balanced...
powercfg -setactive SCHEME_BALANCED >nul 2>&1
echo ✓ Power plan vraćen

echo.
echo Omogućavanje Game DVR...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v GameDVR_Enabled /t REG_DWORD /d 1 /f >nul 2>&1
echo ✓ Game DVR omogućen

echo.
echo Omogućavanje servisa...
sc config "SysMain" start= auto >nul 2>&1
sc start "SysMain" >nul 2>&1
sc config "WSearch" start= auto >nul 2>&1
sc start "WSearch" >nul 2>&1
echo ✓ Servisi vraćeni

echo.
echo =====================================================
echo           POSTAVKE USPEŠNO VRAĆENE!
echo =====================================================
echo.
echo Restartujte računar da bi se sve postavke primenile.
pause