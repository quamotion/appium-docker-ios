FROM mcr.microsoft.com/windows/servercore:2004
# FROM mcr.microsoft.com/windows/servercore:ltsc2019

LABEL maintainer="frederik.carlier@quamotion.mobi"

# https://github.com/StefanScherer/dockerfiles-windows/blob/main/chocolatey/Dockerfile
ENV chocolateyUseWindowsCompression false

# https://medium.com/@sebagomez/windows-containers-personal-cheat-sheet-95c1c4d6bdf5
RUN powershell -Command \
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')); \
    choco feature disable --name showDownloadProgress
RUN choco install -y appium-desktop
