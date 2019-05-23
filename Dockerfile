FROM ubuntu:bionic

ARG appium_version=1.13.0
ARG node_version=10.x
LABEL maintainer "Frederik Carlier <frederik.carlier@quamotion.mobi>"

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /

## Update Ubuntu, install curl
RUN apt-get update \
&& apt-get install -y software-properties-common apt-transport-https curl wget

## Install node.js
RUN curl -sL https://deb.nodesource.com/setup_$node_version -o setup-nodejs \
&& /bin/bash setup-nodejs \
&& rm setup-nodejs \
&& apt-get install -y nodejs

## Install Appium
RUN npm install -g appium@${appium_version} --unsafe-perm=true --allow-root

## Install libimobiledevice
RUN add-apt-repository -y ppa:quamotion/ppa \
&& apt-get install -y --no-install-recommends libplist-dev libusbmuxd-dev libusbmuxd-tools libimobiledevice-dev

## Install xcuitrunner
ARG xcuitrunner_version=0.118.20-g69f2c6b29b
ARG ios_deploy_version=0.118.20-g69f2c6b29b

# TODO: Fix libssl dependency on Ubuntu 18.04 for xcuitrunner
RUN wget -nv -nc -O xcuitrunner.${xcuitrunner_version}.ubuntu.18.04-x64.deb http://cdn.quamotion.mobi/download/xcuitrunner.${xcuitrunner_version}.ubuntu.18.04-x64.deb \
&& dpkg -i xcuitrunner.${xcuitrunner_version}.ubuntu.18.04-x64.deb \
&& rm xcuitrunner.${xcuitrunner_version}.ubuntu.18.04-x64.deb

RUN wget -nv -nc -O ios-deploy.${ios_deploy_version}.ubuntu.18.04-x64.deb http://cdn.quamotion.mobi/download/ios-deploy.${ios_deploy_version}.ubuntu.18.04-x64.deb \
&& dpkg -i ios-deploy.${ios_deploy_version}.ubuntu.18.04-x64.deb \
&& rm ios-deploy.${ios_deploy_version}.ubuntu.18.04-x64.deb

## Cleanup
RUN rm -rf /var/lib/apt/lists/*