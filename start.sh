#!/bin/sh

# Make sure /var/run/usbmuxd exists
if [ ! -S /var/run/usbmuxd ];
then
    echo "The /var/run/usbmuxd socket does not exist. Make sure usbmuxd is running on your host, and you mounted"
    echo "/var/run/usbmuxd in your Docker container."
    exit 1
fi

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