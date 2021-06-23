@echo off
if EXIST instalation.log del instalation.log>nul
:: get discord executable
:: done with a for cuz several processes but only save the first
if "%~1" == "" (
	for /f "skip=1 delims=" %%a IN ('wmic process where "name='discord.exe'" get ExecutablePath') do (
		if not defined d_exe (
			set d_exe=%%a
		)
	)
) else (
	set d_exe=%1
)
if "%d_exe%"=="" (
	echo [ERROR!] Discord needs to be running...
	pause>nul
	goto EOF
)
cls

echo --- Installer ---
echo.

echo Working...
:: set discord executable path
for %%a IN ("%d_exe%") do set d_path=%%~dpa
:: get discord version from a file
for /f "tokens=7 delims=\" %%a IN ("%d_path%") do set d_ver=%%a
for /f "tokens=2 delims=-" %%a IN ("%d_ver%") do set d_ver=%%a
:: set discord core path
if "%~3" == "" (
	set d_core=%APPDATA%\discord\%d_ver%\modules\discord_desktop_core
) else (
	set d_core=%APPDATA%\%3\%d_ver%\modules\discord_desktop_core
)

:: New path
set d_core=%d_path%modules\discord_desktop_core-2\discord_desktop_core


:: make a backup if it doesnt already exist
if NOT EXIST "%d_core%\index.js.bak" (
	move "%d_core%\index.js" "%d_core%\index.js.bak">nul
	echo Backed up to "%d_core%\index.js.bak">>instalation.log
) else (
	echo Backup already exists at "%d_core%\index.js.bak">>instalation.log
)

:: modify files to point to current dir
if EXIST preload.js del preload.js>nul
for /f "delims=" %%a in (.files\preload-original.js) do (
	set _temp=%%a
	SETLOCAL EnableDelayedExpansion
		set modified=!_temp:{{FILE}}=%~dp0.files\injection.js!
		set modified=!modified:\=\\!
		echo !modified!>>preload.js
	ENDLOCAL
)
echo Modified preload.js to point to "%~dp0.files\injection.js">>instalation.log

if EXIST .files\injection.js del .files\injection.js>nul
for /f "delims=" %%a in (.files\injection-original.js) do (
	set _temp=%%a
	SETLOCAL EnableDelayedExpansion
		set modified=!_temp:{{PATH}}=%~dp0!
		if NOT "!modified!" == "!_temp!" (
			set modified=!modified:\=\\!
		)
		echo !modified!>>.files\injection.js
	ENDLOCAL
)
echo Modified injection.js to point to "%~dp0">>instalation.log


:: close discord to apply changes
if "%~2" == "" (
	taskkill /F /im discord.exe /T>nul
) else (
	taskkill /F /im %2 /T>nul
)
echo Killed discord processes to change files>>instalation.log

:: move files
copy .files\index.js "%d_core%\">nul
move preload.js "%d_core%\">nul
xcopy .files\.node\* "%d_core%\" /s /y>nul
echo Moved files to "%d_core%">>instalation.log

echo.
echo --- SUCCESS ---

:: restart discord
if "%~2" == "" (
	start "" "%d_path%Discord.exe"
) else (
	start "" "%d_path%%2"
)

:EOF
