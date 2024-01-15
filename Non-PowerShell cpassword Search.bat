cd /d "%~dp0"

md "Enum-Output"
cd "Enum-Output"

echo Started %date% %time% Non-PowerShell cpassword Search >> progress.log

echo ____SYSVOL cpassword strings____ >> progress.log
findstr /I /S cpassword %logonserver%\sysvol\*.xml > sysvol--cpassword_search.txt

echo Finished %date% %time% >> progress.log