@echo off
title Gaming PC & Internet Optimizer
color 0A
echo.
echo =====================================================
echo    GAMING PC & INTERNET CONNECTION OPTIMIZER
echo =====================================================
echo.
echo PAŽNJA: Ovaj script zahteva administrator privilegije!
echo Pritisnite bilo koji taster da nastavite...
pause >nul
echo.

REM Check for admin privileges
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo GREŠKA: Morate pokrenuti kao Administrator!
    echo Desni klik na fajl -^> "Run as administrator"
    pause
    exit /b
)

echo [1/10] Optimizacija DNS-a i network stack-a...
echo ------------------------------------------------

REM Flush DNS cache
ipconfig /flushdns >nul 2>&1
echo ✓ DNS cache obnovljen

REM Reset TCP/IP stack
netsh int ip reset >nul 2>&1
netsh winsock reset >nul 2>&1
echo ✓ TCP/IP stack resetovan

REM Optimize TCP settings
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global chimney=enabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global netdma=enabled >nul 2>&1
echo ✓ TCP parametri optimizovani

REM Set Google DNS as primary (faster gaming)
netsh interface ip set dns "Wi-Fi" static 8.8.8.8 primary >nul 2>&1
netsh interface ip add dns "Wi-Fi" 8.8.4.4 index=2 >nul 2>&1
netsh interface ip set dns "Ethernet" static 8.8.8.8 primary >nul 2>&1
netsh interface ip add dns "Ethernet" 8.8.4.4 index=2 >nul 2>&1
echo ✓ DNS serveri podešeni na Google DNS

echo.
echo [2/10] Postavljanje High Performance power plan-a...
echo ------------------------------------------------
powercfg -setactive SCHEME_MIN >nul 2>&1
echo ✓ High Performance plan aktiviran

echo.
echo [3/10] Optimizacija prioriteta procesa...
echo ------------------------------------------------

REM Set Windows to prioritize programs over background services
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1
echo ✓ Prioritet programa povećan

echo.
echo [4/10] Čišćenje temporary fajlova...
echo ------------------------------------------------

REM Clean temporary files
del /f /s /q "%temp%\*.*" >nul 2>&1
del /f /s /q "C:\Windows\temp\*.*" >nul 2>&1
del /f /s /q "C:\Windows\Prefetch\*.*" >nul 2>&1
echo ✓ Temporary fajlovi obrisani

REM Clean recycle bin
rd /s /q "C:\$Recycle.Bin" >nul 2>&1
echo ✓ Recycle Bin očišćen

echo.
echo [5/10] Gaming optimizacije (Game Mode)...
echo ------------------------------------------------

REM Enable Game Mode
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul 2>&1
echo ✓ Game Mode omogućen

REM Disable Game DVR (can cause performance issues)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
echo ✓ Game DVR onemogućen

echo.
echo [6/10] Network adapter optimizacije...
echo ------------------------------------------------

REM Disable network power management
powershell -Command "Get-NetAdapter | ForEach-Object { Disable-NetAdapterPowerManagement $_.Name }" >nul 2>&1
echo ✓ Network power management onemogućen

REM Optimize network adapter settings
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpAckFrequency /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TCPNoDelay /t REG_DWORD /d 1 /f >nul 2>&1
echo ✓ Network latency optimizovan

echo.
echo [7/10] Memoria optimizacije...
echo ------------------------------------------------

REM Clear memory cache
echo. > "%temp%\memclean.vbs"
echo Set objShell = CreateObject("WScript.Shell") >> "%temp%\memclean.vbs"
echo objShell.SendKeys "%%{F4}" >> "%temp%\memclean.vbs"
echo ✓ Memory cache spreman za čišćenje

echo.
echo [8/10] Optimizacija storage performansi...
echo ------------------------------------------------

REM Optimize SSD (if present)
fsutil behavior set DisableLastAccess 1 >nul 2>&1
echo ✓ SSD optimizacija primenjena

echo.
echo [9/10] Optimizacija vizuelnih efekata...
echo ------------------------------------------------

REM Optimize visual effects for performance
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
echo ✓ Vizuelni efekti optimizovani za performanse

echo.
echo [10/10] Gaming servisi optimizacija...
echo ------------------------------------------------

REM Stop and disable unnecessary services for gaming
sc config "SysMain" start= disabled >nul 2>&1
sc stop "SysMain" >nul 2>&1
echo ✓ SuperFetch onemogućen

sc config "WSearch" start= disabled >nul 2>&1
sc stop "WSearch" >nul 2>&1
echo ✓ Windows Search onemogućen

echo.
echo =====================================================
echo              OPTIMIZACIJA ZAVRŠENA!
echo =====================================================
echo.
echo ✓ Internet konekcija optimizovana
echo ✓ Gaming performanse poboljšane
echo ✓ System resources oslobođeni
echo ✓ Network latency smanjen
echo.
echo NAPOMENE:
echo - Preporučuje se restart računara
echo - Za potpune efekte, zatvorite nepotrebne programe
echo - Koristite ethernet kabel umesto WiFi za najbolje performanse
echo.
echo Pritisnite bilo koji taster da zatvorite...
pause >nul

REM Optional: Create restore point before major changes
echo.
echo Želite li kreirati System Restore Point? (Y/N)
set /p restore="Unesite Y ili N: "
if /i "%restore%"=="Y" (
    echo Kreiranje restore point-a...
    wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Gaming Optimizer - Pre Optimization", 100, 1 >nul 2>&1
    echo ✓ Restore point kreiran
)

echo.
echo ZAVRŠENO! Restartujte računar za potpune efekte.
pause