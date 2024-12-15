@echo off
color 0A
mode 69,31

title System Compilation

:: Initial Welcome
echo  ==================================================================
echo                            WELCOME!
echo  ==================================================================
timeout /t 2 /nobreak >nul
cls

echo  ==================================================================
echo                    Data will start loading soon...
echo  ==================================================================
timeout /t 2 /nobreak >nul
cls

setlocal enabledelayedexpansion

:: Retrieve system stats
for /f "tokens=3 delims= " %%a in ('tasklist ^| find "System Idle Process"') do set cpu=%%a
for /f "tokens=1 delims=K" %%a in ('systeminfo ^| find "Available Physical Memory"') do set memfree=%%a
for /f "tokens=1,2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4 Address"') do set ip=%%b
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"Default Gateway"') do set gateway=%%a

:: External IP (requires curl)
for /f %%a in ('curl -s ifconfig.me') do set extip=%%a

:: Internet connectivity status
ping -n 1 google.com >nul
if %errorlevel%==0 (
    set connection=Connected
) else (
    set connection=Disconnected
)

:loop
:: Retrieve network stats
for /f "tokens=2 delims=:" %%a in ('netsh wlan show interface ^| find "SSID" ^| findstr /v "BSSID"') do set ssid=%%a
for /f "tokens=2 delims=:" %%a in ('netsh wlan show interface ^| find "Description"') do set adapter=%%a
for /f "tokens=2 delims=:" %%a in ('netsh wlan show interface ^| find "State"') do set state=%%a
for /f "tokens=2 delims=:" %%a in ('netsh wlan show interface ^| find "Signal"') do set signal=%%a

:: Retrieve ping stats
ping -n 3 8.8.8.8>%temp%\ping.txt
for /f "tokens=4 delims==" %%a in ('type %temp%\ping.txt ^| find "Average"') do set ping=%%a
for /f "tokens=10 delims= " %%a in ('type %temp%\ping.txt ^| find "Lost"') do set ploss=%%a

:: Retrieve bytes sent/received
for /f "tokens=2 delims= " %%a in ('netstat -e ^| find "Bytes"') do set rbytes=%%a
for /f "tokens=3 delims= " %%a in ('netstat -e ^| find "Bytes"') do set sbytes=%%a

:: Retrieve system time info
for /f "tokens=* delims=" %%a in ('time/t') do set time=%%a

cls
echo  ===================================================================
echo                          SYSTEM DATA HUB
echo  ===================================================================
echo.
echo  SYSTEM INFO:
echo  ------------
echo  Time       : !time!
echo  CPU Usage  : !cpu!%% Idle
echo  Free Memory: !memfree!
echo.
echo  NETWORK CONNECTION:
echo  -------------------
echo  SSID         : !ssid!
echo  Adapter      : !adapter!
echo  Status       : !state!
echo  Signal       : !signal!
echo  IP Address   : !ip!
echo  Gateway      : !gateway!
echo  External IP  : !extip!

echo.
echo  CONNECTION PERFORMANCE:
echo  ----------------------
echo  Ping         : !ping!
echo  Packet Loss  : !ploss!
echo  Bytes Recv   : !rbytes!
echo  Bytes Sent   : !sbytes!
echo.
echo  ===================================================================
echo                          CTRL + C to quit
echo  ===================================================================
goto loop
