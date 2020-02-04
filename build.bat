@echo off
for %%I in (.) do set addon=%%~nxI
if not exist "%~dp0..\..\AddOns%addon%" mkdir "%~dp0..\..\AddOns\%addon%"
xcopy /y "%~dp0*.lua" "%~dp0..\..\AddOns\%addon%"
xcopy /y "%~dp0%addon%.toc" "%~dp0..\..\AddOns\%addon%" /s /d
pause