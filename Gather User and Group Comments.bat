cd /d "%~dp0"

md "Enum-Output"
cd "Enum-Output"

echo Started %date% %time% Gathering User and Group Comments >> progress.log

echo ____Domain User Comments____ >> progress.log
for /F "tokens=1,2,3" %%i in ('net user /domain ^| findstr /V "^$"') do net user /domain %%i >> comments--domain_users.txt & net user /domain %%j >> comments--domain_users.txt & net user /domain %%k >> comments--domain_users.txt

echo ____Domain Group Comments____ >> progress.log
for /F "tokens=1,2 delims=*" %%i in ('net group /domain') do net group /domain "%%i" >> comments--domain_groups.txt