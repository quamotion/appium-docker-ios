[![Docker Pulls](https://img.shields.io/docker/pulls/quamotion/appium-docker-ios.svg?style=flat-square)](https://hub.docker.com/r/quamotion/appium-docker-ios/)
[![Docker Image](https://images.microbadger.com/badges/image/quamotion/appium-docker-ios.svg)](https://microbadger.com/images/quamotion/appium-docker-ios)
[![Build Status](https://dev.azure.com/qmfrederik/appium-docker-ios/_apis/build/status/quamotion.appium-docker-ios?branchName=master)](https://dev.azure.com/qmfrederik/appium-docker-ios/_build/latest?definitionId=17&branchName=master)

# Appium Docker for iOS

This repository contains the scripts used to build the [quamotion/appium-docker-ios](https://hub.docker.com/r/quamotion/appium-docker-ios)
Docker image. It contains all the software required to build and run Appium with
real, physical iOS devices on Linux.

The Docker image includes software from [Quamotion](http://quamotion.mobi)
which make it possible to run Appium Docker for iOS on Linux. This software is available
under a commercial license from [Quamotion](http://quamotion.mobi), contact us at
info@quamotion.mobi for more information.

## What the container does

If you run a container based on this image, it will set up an Appium server which you can use
to automate iOS device.

## Requirements

Before you can run Appium tests on real, physical iOS devices from Linux, you will first need:

- An iOS device device.
- A Developer Certificate and a Provisioning Profile which can be used to sign iOS applications
  and install them on your iOS device. See [Configure Developer Profiles](http://docs.quamotion.mobi/docs/webdriver/configuration/developerprofile/)
  for more information.
- The Developer Disk Images for the version of iOS which is running on your device.
  See [the Quamotion documentation](http://docs.quamotion.mobi/docs/webdriver/configuration/developerdisk/)
  for more information.
- Install [Docker](). Most Linux distributions include a recent version of Docker.
- Install [usbmuxd](https://github.com/libimobiledevice/usbmuxd) on your computer.
  Most Linux distributions include a recent version of usbmuxd.

appium-docker-ios runs on x86_64 and arm64 processor architectures. This means you
can run appium-docker-ios on a Raspberry Pi 3 or later!
You can check your processor architecture by running `uname -m`.

## Prepare your computer for appium-docker-ios

### Pairing your iOS device with your computer

First, you'll need to pair your iOS device with your computer. To do this:

1. Install usbmuxd and the libimobiledevice. On Ubuntu, you should be able
   to run `sudo apt-get install -y usbmuxd libimobiledevice-utils`.
2. Connect your iOS device to your computer using an USB cable. You should
   see a pairing dialog on your device. Accept the pairing request.
3. Run `idevice_id -l`. It should output the UDID (unique ID) of your device.

### Installing Docker

You should install a recent version of Docker on your computer. On Ubuntu
Linux, you can run `sudo apt-get install -y docker.io`.

### Preparing the Quamotion configuration

Create a folder in which you will store your developer disk images,
your developer profile and your developer profile password. In this
tutorial, we'll use the `.quamotion` hidden folder in the user directory.

1. Create the directory: `mkdir -p ~/.quamotion`
2. Copy your developer disk images to the `~/.quamotion/devimg` directory
3. Copy your developer profile to `~/.quamotion/quamotion.developerprofile`.
4. Save the password for your developer profile in the file `~/.quamotion/quamotion.developerprofile.password`.

## Starting the container

All set! You're ready to start Appium for iOS on your Linux machine.

Start the container using the following command:

```bash
docker run \
    -p 4723:4723 \
    -v /var/run/usbmuxd:/var/run/usbmuxd \
    -v ~/.quamotion/:/etc/quamotion/
    -e DEVELOPER_PROFILE_PASSWORD=1 \ # You won't need this in newer versions!
    --name appium-docker-ios
    quamotion/appium-docker-ios
```

The Appium server should start:

```
ios@quamotion:~/$ docker run -p 4723:4723 -v /var/run/usbmuxd:/var/run/usbmuxd -v ~/.quamotion:/etc/quamotion -e DEVELOPER_PROFILE_PASSWORD=1 quamotion/appium-docker-ios
[Appium] Welcome to Appium v1.18.1
[Appium] Appium REST http interface listener started on 0.0.0.0:4723
```

You can check the version of Appium which is running by running the following command:

```bash
ios@quamotion:~/$ curl -X GET http://localhost:4723/wd/hub/status
{"value":{"build":{"version":"1.18.1"}},"sessionId":null,"status":0}
```

## Starting an Appium session

To start an Appium session on your iOS device:

- Connect to the Appium server running at http://localhost:4723
- Set the following capabilities:
  * `platformName` : `iOS`
  * `automationName` : `XCUITest`
  * `deviceName` : `iPhone`,
  * `udid` : The UDID of your device
  * `bundleId` : `com.apple.Preferences` (to launch the Preferences app)

For example, you could `POST http://localhost:4723/wd/hub/session` with header `Content-Type: application/json`:

```json
{
  "desiredCapabilities":
  {
    "platformName":"iOS",
    "automationName":"XCUITest",
    "deviceName":"iPhone",
    "udid":"72157b76f677f22c98864d62307fdff9d56fa62a",
    "bundleId":"com.apple.Preferences"
  }
}
```

This will start the Preferences application on the iOS device with UDID 72157b76f677f22c98864d62307fdff9d56fa62a.

## Questions?

This repository is maintained by [Quamotion](http://quamotion.mobi).
Quamotion develops test automation software for iOS applications, based on the WebDriver protocol.

In certain cases, Quamotion also offers professional services - such as consulting, training and support.
Contact us at info@quamotion.mobi for more information.