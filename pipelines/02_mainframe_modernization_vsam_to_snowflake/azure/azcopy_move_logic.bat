@echo off

:: Purpose: Move files from Landing Root to Process/Archive after IICS trigger
:: Challenge Solved: Sub-folder path resolution bug in IICS File Listener

:: pick the single long string in %1, coming from IICS taskflow command task
set "RAW_INPUT=%~1"

:: unstring the long string using space delimiter and put the paths in 2 variables
for /f "tokens=1,2" %%a in ("%RAW_INPUT%") do (
    set "PROC_DIR=%%a"
    set "ARCH_DIR=%%b"
)

:: Argument %%a is v_proc_dir, Argument %b% is v_archive_dir
set "SAS=<YOUR_SAS_TOKEN>"
set "BASE_URL=https://<YOUR_AZURE_STORAGE_ACCOUNT>.blob.core.windows.net/mainframe-data"

:: 1. Move JSON files (Copy + Delete)
"C:\..\Informatica Cloud Secure Agent\azcopy.exe" copy "%BASE_URL%/*?%SAS%" "%BASE_URL%/%PROC_DIR%?%SAS%" --include-pattern "*.json" --recursive=false
"C:\..\Informatica Cloud Secure Agent\azcopy.exe" remove "%BASE_URL%/*?%SAS%" --include-pattern "*.json"

:: 2. Moving the file that triggered the listener, to Archive (Copy + Delete)
"C:\..\Informatica Cloud Secure Agent\azcopy.exe" copy "%BASE_URL%/*?%SAS%" "%BASE_URL%/%ARCH_DIR%?%SAS%" --include-pattern "*.dat" --recursive=false
"C:\..\Informatica Cloud Secure Agent\azcopy.exe" remove "%BASE_URL%/*?%SAS%" --include-pattern "*.dat"
