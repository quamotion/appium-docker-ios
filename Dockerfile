FROM ubuntu:focal

ARG appium_version=1.18.1
ARG node_version=12.x
LABEL maintainer "Frederik Carlier <frederik.carlier@quamotion.mobi>"

EXPOSE 4723

ENV DEBIAN_FRONTEND=noninteractive

# Don't install the ChromeDriver, which is used for Android automation.
ENV APPIUM_SKIP_CHROMEDRIVER_INSTALL=1

# Setting NODE_ENV=production should make sure npm does not install development
# dependencies.
ENV NODE_ENV=production

# Install xcuitrunner
ARG xcuitrunner_version=0.150.31

WORKDIR /appium

## Install wget (required to install nodejs).
RUN apt-get update \
&& apt-get install -y --no-install-recommends wget ca-certificates \
## Install node.js
&& wget -nv https://deb.nodesource.com/setup_$node_version -O setup-nodejs \
&& /bin/bash setup-nodejs \
&& rm setup-nodejs \
&& apt-get install -y nodejs \
## Install Appium
&& npm install -g appium@${appium_version} --unsafe-perm=true --allow-root \
## Install xcuitrunner dependencies
&& apt-get install -y --no-install-recommends libusbmuxd-tools libturbojpeg libvncserver1 libicu66 libgssapi-krb5-2 \
## Install xcuitrunner
&& architecture=$(uname -m) \
&& case "$architecture" in \
    x86_64) \
        architecture=x64 \
        ;; \
    aarch64) \
        architecture=arm64 \
        ;; \
esac \
&& wget -nv http://cdn.quamotion.mobi/download/xcuitrunner.${xcuitrunner_version}.linux-${architecture}.deb -O xcuitrunner.${xcuitrunner_version}.linux-${architecture}.deb \
&& dpkg -i xcuitrunner.${xcuitrunner_version}.linux-${architecture}.deb \
&& rm xcuitrunner.${xcuitrunner_version}.linux-${architecture}.deb \
## Cleanup
&& apt-get remove -y wget gnupg ca-certificates \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

COPY start.sh .
ENV PATH="/usr/share/xcuitrunner:${PATH}"

CMD [ "/bin/sh", "./start.sh" ]
