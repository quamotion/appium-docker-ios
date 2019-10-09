FROM ubuntu:bionic

ARG appium_version=1.15.0
ARG node_version=10.x
LABEL maintainer "Frederik Carlier <frederik.carlier@quamotion.mobi>"

EXPOSE 4723
EXPOSE 8100

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /appium

## Update Ubuntu, install curl
RUN apt-get update \
&& apt-get install -y software-properties-common apt-transport-https curl wget \
## Install node.js
&& curl -sL https://deb.nodesource.com/setup_$node_version -o setup-nodejs \
&& /bin/bash setup-nodejs \
&& rm setup-nodejs \
&& apt-get install -y nodejs \
## Install Appium
&& npm install -g appium@${appium_version} --unsafe-perm=true --allow-root \
## Install libimobiledevice
&& add-apt-repository -y ppa:quamotion/ppa \
&& apt-get install -y --no-install-recommends libplist-dev libusbmuxd-dev libusbmuxd-tools libimobiledevice-dev libimobiledevice-utils \
## For debug purposes only
&& apt-get install -y nano \
## Cleanup
&& rm -rf /var/lib/apt/lists/*

## Install xcuitrunner
ARG xcuitrunner_version=0.127.81
ARG ios_deploy_version=0.127.81

RUN wget -nv -nc -O xcuitrunner.${xcuitrunner_version}.ubuntu.18.04-x64.deb http://cdn.quamotion.mobi/download/xcuitrunner.${xcuitrunner_version}.ubuntu.18.04-x64.deb \
&& dpkg -i xcuitrunner.${xcuitrunner_version}.ubuntu.18.04-x64.deb \
&& rm xcuitrunner.${xcuitrunner_version}.ubuntu.18.04-x64.deb

## Install ios-deploy, and make sure it is on the path
RUN wget -nv -nc -O ios-deploy.${ios_deploy_version}.ubuntu.18.04-x64.deb http://cdn.quamotion.mobi/download/ios-deploy.${ios_deploy_version}.ubuntu.18.04-x64.deb \
&& dpkg -i ios-deploy.${ios_deploy_version}.ubuntu.18.04-x64.deb \
&& rm ios-deploy.${ios_deploy_version}.ubuntu.18.04-x64.deb \
&& ln -s /usr/share/ios-deploy/ios-deploy /usr/bin/ios-deploy

## Create Xcode stubs
COPY xcode /usr/local/xcode
ENV DEVELOPER_DIR="/usr/local/xcode"
ENV PATH="${DEVELOPER_DIR}:${PATH}"

COPY start.sh .

CMD [ "/bin/sh", "./start.sh" ]