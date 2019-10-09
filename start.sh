#!/bin/sh

# Make sure /var/run/usbmuxd exists
if [ ! -S /var/run/usbmuxd ];
then
    echo "The /var/run/usbmuxd socket does not exist. Make sure usbmuxd is running on your host, and you mounted"
    echo "/var/run/usbmuxd in your Docker container."
    exit 1
fi

if [ -z "${UDID}" ];
then
    if [ $(idevice_id -l | wc -l) = "1" ];
    then
        export UDID=`idevice_id -l`
    else
        if [ $(idevice_id -l | wc -l) = "0" ];
        then
            echo "No iOS devices are connected to this Docker container."
            exit 1
        else
            echo "More than one iOS device is connected to this Docker container. Please specify on which device"
            echo "you want to run tests, by setting the 'UDID' environment variable to the UDID of your device."
            echo ""
            echo "The following devices are currently connected:"
            idevice_id -l
            exit 1
        fi
    fi
else
    if [ ! $(idevice_id -l | grep $UDID | wc -l) = "1" ];
    then
        echo "The iOS device with UDID '$UDID' is not connected to this Docker container."
        echo ""
        echo "The following devices are currently connected:"
        idevice_id -l
        exit 1
    fi
fi

echo "Setting up Appium to run on the iOS device with UDID '${UDID}'"

if [ ! -f /quamotion/quamotion.developerprofile ];
then
    echo "You have not provided a developer profile. Please mount your developer profile"
    echo "to /quamotion/quamotion.developerprofile, and try again."
    exit 1
fi

if [ -z "${DEVELOPER_PROFILE_PASSWORD}" ];
then
    echo "You have not specified a password for use with your developer profile."
    echo "Please set the DEVELOPER_PROFILE_PASSWORD environment variable, and try"
    echo "again."
    exit 1
fi

if [ ! -f /quamotion/.license ];
then
    echo "You have not specified a license file. Please mount your license file"
    echo "into /quamotion/.license, and try again"
    exit 1
fi

appium