@echo off
setlocal EnableExtensions EnableDelayedExpansion
title IT Toolkit - Common Fixes

:: --- Self-elevate to Admin ---
net session >nul 2>&1
if not "%errorlevel%"=="0" (
  echo Requesting administrator rights...
  powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

:: --- Init logging ---
for /f "tokens=1-4 delims=/ " %%a in ("%date%") do set _d=%%a-%%b-%%c
set _t=%time::=-%
set _t=%_t: =0%
set LOG=%TEMP%\ITToolkit_%_d%_%_t%.log
echo [%date% %time%] IT Toolkit started > "%LOG%"
echo Log: "%LOG%"
echo.

:MENU
cls
echo ================= IT TOOLKIT =================
echo  1 ^) Flush DNS and re-register
echo  2 ^) Reset Winsock
echo  3 ^) Reset TCP/IP stack
echo  4 ^) Release and renew IP
echo  5 ^) Quick network test
echo  6 ^) System File Checker (SFC)
echo  7 ^) DISM ScanHealth
echo  8 ^) DISM RestoreHealth
echo  9 ^) Restart Print Spooler and clear queue
echo 10 ^) Clean temp files
echo 11 ^) Schedule CHKDSK on C: (/F)
echo 12 ^) Show adapter info (ipconfig /all)
echo  0 ^) Exit
echo ==============================================
set /p CH=Choose an option: 

if "%CH%"=="1" goto FLUSHDNS
if "%CH%"=="2" goto WINSOCK
if "%CH%"=="3" goto IPRESET
if "%CH%"=="4" goto RENEW
if "%CH%"=="5" goto NETTEST
if "%CH%"=="6" goto SFC
if "%CH%"=="7" goto DISMSCAN
if "%CH%"=="8" goto DISMRESTORE
if "%CH%"=="9" goto PRINT
if "%CH%"=="10" goto CLEANTEMP
if "%CH%"=="11" goto CHKDSK
if "%CH%"=="12" goto IPCONFIGALL
if "%CH%"=="0" goto END
goto MENU

:FLUSHDNS
echo.
echo [DNS] Flushing and re-registering...
echo [%date% %time%] ipconfig /flushdns >> "%LOG%"
ipconfig /flushdns >> "%LOG%" 2>&1
echo [%date% %time%] ipconfig /registerdns >> "%LOG%"
ipconfig /registerdns >> "%LOG%" 2>&1
echo Done. Press any key to continue.
pause >nul
goto MENU

:WINSOCK
echo.
echo [Network] Resetting Winsock...
echo [%date% %time%] netsh winsock reset >> "%LOG%"
netsh winsock reset >> "%LOG%" 2>&1
echo You may need to restart Windows. Press any key to continue.
pause >nul
goto MENU

:IPRESET
echo.
echo [Network] Resetting TCP/IP stack...
echo [%date% %time%] netsh int ip reset >> "%LOG%"
netsh int ip reset >> "%LOG%" 2>&1
echo You may need to restart Windows. Press any key to continue.
pause >nul
goto MENU

:RENEW
echo.
echo [Network] Releasing and renewing IP...
echo [%date% %time%] ipconfig /release >> "%LOG%"
ipconfig /release >> "%LOG%" 2>&1
echo [%date% %time%] ipconfig /renew >> "%LOG%"
ipconfig /renew >> "%LOG%" 2>&1
echo Done. Press any key to continue.
pause >nul
goto MENU

:NETTEST
echo.
echo [Test] Quick connectivity checks...
echo [%date% %time%] ping 8.8.8.8 -n 4 >> "%LOG%"
ping 8.8.8.8 -n 4 | tee.exe 2>nul
echo [%date% %time%] ping www.google.com -n 4 >> "%LOG%"
ping www.google.com -n 4 | tee.exe 2>nul
echo [%date% %time%] nslookup www.microsoft.com >> "%LOG%"
nslookup www.microsoft.com | tee.exe 2>nul
echo [%date% %time%] tracert 8.8.8.8 >> "%LOG%"
tracert 8.8.8.8 | tee.exe 2>nul
echo Results saved to %LOG%.
echo Press any key to continue.
pause >nul
goto MENU

:SFC
echo.
echo [System] Running SFC scan. This can take a while...
echo [%date% %time%] sfc /scannow >> "%LOG%"
sfc /scannow >> "%LOG%" 2>&1
echo SFC completed. Review log if issues persist: %LOG%
echo Press any key to continue.
pause >nul
goto MENU

:DISMSCAN
echo.
echo [System] DISM ScanHealth...
echo [%date% %time%] DISM /Online /Cleanup-Image /ScanHealth >> "%LOG%"
DISM /Online /Cleanup-Image /ScanHealth >> "%LOG%" 2>&1
echo Done. Press any key to continue.
pause >nul
goto MENU

:DISMRESTORE
echo.
echo [System] DISM RestoreHealth...
echo [%date% %time%] DISM /Online /Cleanup-Image /RestoreHealth >> "%LOG%"
DISM /Online /Cleanup-Image /RestoreHealth >> "%LOG%" 2>&1
echo Completed. A reboot may be recommended. Press any key to continue.
pause >nul
goto MENU

:PRINT
echo.
echo [Print] Clearing queue and restarting spooler...
echo [%date% %time%] net stop spooler >> "%LOG%"
net stop spooler >> "%LOG%" 2>&1
echo [%date% %time%] Deleting %SystemRoot%\System32\spool\PRINTERS\* >> "%LOG%"
del /q /f "%SystemRoot%\System32\spool\PRINTERS\*" >> "%LOG%" 2>&1
echo [%date% %time%] net start spooler >> "%LOG%"
net start spooler >> "%LOG%" 2>&1
echo Done. Press any key to continue.
pause >nul
goto MENU

:CLEANTEMP
echo.
echo [Cleanup] Removing temp files for current user...
echo [%date% %time%] del /q /f /s "%TEMP%\*" >> "%LOG%"
del /q /f /s "%TEMP%\*" >> "%LOG%" 2>&1
echo You can also run Disk Cleanup for deeper cleanup.
echo Press any key to continue.
pause >nul
goto MENU

:CHKDSK
echo.
echo [Disk] Scheduling CHKDSK C: /F at next boot...
echo [%date% %time%] chkntfs /C C: >> "%LOG%"
chkntfs /C C: >> "%LOG%" 2>&1
echo [%date% %time%] chkdsk C: /F >> "%LOG%"
echo You may be prompted to schedule on reboot. Type Y if asked.
chkdsk C: /F
echo Press any key to continue.
pause >nul
goto MENU

:IPCONFIGALL
echo.
echo [Info] Adapter details (ipconfig /all)...
echo [%date% %time%] ipconfig /all >> "%LOG%"
ipconfig /all | more
echo Saved to %LOG%.
echo Press any key to continue.
pause >nul
goto MENU

:END
echo Exiting. Log saved at: %LOG%
timeout /t 1 >nul
endlocal
exit /b
