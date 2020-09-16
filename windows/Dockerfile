FROM mcr.microsoft.com/windows/servercore:ltsc2019

LABEL maintainer="frederik.carlier@quamotion.mobi"

# https://medium.com/@sebagomez/windows-containers-personal-cheat-sheet-95c1c4d6bdf5
RUN powershell -Command Invoke-WebRequest https://github.com/appium/appium-desktop/releases/download/v1.18.0-2/Appium-windows-1.18.0-2.zip -UseBasicParsing -OutFile C:\Appium-windows-1.18.0-2.zip
RUN powershell -Command Expand-Archive -Path C:\Appium-windows-1.18.0-2.zip -DestinationPath C:\appium
