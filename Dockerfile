FROM ubuntu:focal

ARG appium_version=1.18.1
ARG node_version=12.x
LABEL maintainer "Frederik Carlier <frederik.carlier@quamotion.mobi>"

EXPOSE 4723
EXPOSE 8100

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /appium

## Update Ubuntu, install curl (required to install nodejs)
RUN apt-get update \
&& apt-get install -y --no-install-recommends curl ca-certificates \
## Install node.js
&& curl -sL https://deb.nodesource.com/setup_$node_version -o setup-nodejs \
&& /bin/bash setup-nodejs \
&& rm setup-nodejs \
&& apt-get install -y nodejs \
## Install Appium
&& npm install -g appium@${appium_version} --unsafe-perm=true --allow-root \
## Install libimobiledevice
&& echo "deb http://ppa.launchpad.net/quamotion/ppa/ubuntu $(lsb_release -cs) main" | tee -a /etc/apt/sources.list.d/quamotion.list \
&& curl -L "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x024af839d0ecfa7fc85161d6246b4769e25e7a74" | apt-key add - \
&& apt-get update \
&& apt-get install -y --no-install-recommends libplist-dev libusbmuxd-dev libusbmuxd-tools libimobiledevice-dev libimobiledevice-utils \
## Install other dependencies
&& apt-get install -y --no-install-recommends libturbojpeg libvncserver1 usbmuxd libicu66 \
## Cleanup
&& rm -rf /var/lib/apt/lists/*

## Install xcuitrunner
ARG xcuitrunner_version=0.149.26

RUN curl -sL http://cdn.quamotion.mobi/download/xcuitrunner.${xcuitrunner_version}.linux-x64.deb -o xcuitrunner.${xcuitrunner_version}.linux-x64.deb \
&& dpkg -i xcuitrunner.${xcuitrunner_version}.linux-x64.deb \
&& rm xcuitrunner.${xcuitrunner_version}.linux-x64.deb

COPY start.sh .

CMD [ "/bin/sh", "./start.sh" ]
