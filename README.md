# IT Toolkit (Batch Script)

A menu-driven Windows batch script for quickly running **common IT troubleshooting tasks**.  
Originally built to save time during helpdesk and field support, this script combines several one-liners into a single easy-to-use tool.

---

## Features

- Flush and re-register DNS  
- Reset Winsock and TCP/IP stack  
- Release and renew IP  
- Quick connectivity tests (ping, nslookup, tracert)  
- Run **System File Checker (SFC)**  
- Run **DISM ScanHealth / RestoreHealth**  
- Restart print spooler and clear stuck print jobs  
- Clean temporary files  
- Schedule **CHKDSK /F** on C:  
- Show full adapter info (`ipconfig /all`)  

---

## Usage

1. Download or clone this repo.  
2. Run the script as Administrator:  
3. Use the menu to select the task you need.  
4. Actions and results are logged automatically to a timestamped file in `%TEMP%`.

---

## Example Menu
```bash
================= IT TOOLKIT =================
1 ) Flush DNS and re-register
2 ) Reset Winsock
3 ) Reset TCP/IP stack
4 ) Release and renew IP
5 ) Quick network test
6 ) System File Checker (SFC)
7 ) DISM ScanHealth
8 ) DISM RestoreHealth
9 ) Restart Print Spooler and clear queue
10 ) Clean temp files
11 ) Schedule CHKDSK on C: (/F)
12 ) Show adapter info (ipconfig /all)
0 ) Exit
```
---

## Notes

- Script must be run **as Administrator** for most functions.  
- Some options may prompt for a reboot (Winsock, TCP/IP reset, CHKDSK, DISM RestoreHealth).  
- Results are logged to `%TEMP%\ITToolkit_*.log` for later review.  
- Optional: if you have `tee.exe` installed, output will show live while also saving to the log.

---

## Author
**Jordan Sena**  
System Coordinator • IT & Cybersecurity  
