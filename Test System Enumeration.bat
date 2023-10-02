cd /d "%~dp0"

md "Enum-Output"
cd "Enum-Output"

echo Started %date% %time% > progress.log

echo _____Local users and administrators_____ >> progress.log
net user > local-users.txt
net localgroup administrators > local-admins.txt

echo _____Domain Users_____ >> progress.log
net user /domain > domain-users.txt

echo _____Domain Admins_____ >> progress.log
net group /domain "Domain Admins" > domain-admins.txt

echo _____Enterprise Admins_____ >> progress.log
net group /domain "Enterprise Admins" > enterprise-admins.txt

echo _____Schema Admins_____ >> progress.log
net group /domain "Schema Admins" > schema-admins.txt
    
echo _____Domain Computers_____ >> progress.log
net group /domain "Domain Computers" > domain-computers.txt

echo _____Domain Controllers_____ >> progress.log
net group /domain "Domain Controllers" > domain-controllers.txt
nltest /dclist:%userdomain% > domain-controllers-nltest.txt

echo _____Domain Password Policy_____ >> progress.log
net accounts > password-policy.txt
net accounts /domain >> password-policy.txt

echo _____Domain Trusts_____     >> progress.log
nltest /domain_trusts > domain-trusts.txt

echo _____Test system hostname and ipconfig_____ >> progress.log
echo Username: %USERNAME% > test-system-host-info.txt
echo Hostname: %COMPUTERNAME% >> test-system-host-info.txt
echo Domain name: %USERDOMAIN% >> test-system-host-info.txt
ver >> test-system-host-info.txt
ipconfig /all >> test-system-host-info.txt

echo _____Test user group memberships_____ >> progress.log
net user /domain %username% > test-user-info.txt

echo _____Environment variables_____ >> progress.log
set > environment-variables.txt

echo _____C:\ files_____ >> progress.log
dir /s /a /b C:\ > c-drive.dump

echo ____AutoLogon Registry entries____ >> progress.log
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\winlogon" | findstr /R /I "autoadmin username password domain" >> registry-AutoLogon.txt

echo ____PowerShell console history____ >> progress.log
powershell -c "copy ((get-PSReadlineOption).HistorySavePath) .\PowerShell--ConsoleHost_history.txt"

echo ____Mounted SMB Shared Folders____ >> progress.log
net use 2>&1 > mounted_smb_shares.txt

echo ____Test user group memberships 2 and privileges____ >> progress.log
whoami /groups /priv /fo csv > test-user-groups-and-privs.csv

echo ____Domain User Comments____ >> progress.log
for /F "tokens=1,2,3" %%i in ('net user /domain ^| findstr /V "^$"') do net user /domain %%i >> comments--domain_users.txt & net user /domain %%j >> comments--domain_users.txt & net user /domain %%k >> comments--domain_users.txt

echo ____Domain Group Comments____ >> progress.log
for /F "tokens=1,2 delims=*" %%i in ('net group /domain') do net group /domain "%%i" >> comments--domain_groups.txt

echo ____SYSVOL Group Policy passwords search____ >> progress.log
powershell.exe -c "ls \\$($env:USERDNSDOMAIN)\sysvol\*\Policies\* -Recurse -Include *.xml | select-string password | Set-Content sysvol--password-search.txt -Encoding Ascii -PassThru"

echo ____SYSVOL ALL passwords search____ >> progress.log
powershell.exe -c "ls \\$($env:USERDNSDOMAIN)\sysvol\* -Recurse -Exclude *.adm*,*.dll,*.exe | select-string password | Set-Content sysvol--password-search-FULL.txt -Encoding Ascii -PassThru"

echo ____SYSVOL cpassword strings____ >> progress.log
findstr /I /S cpassword %logonserver%\sysvol\*.xml > sysvol--cpassword_search.txt

echo Finished %date% %time% >> progress.log