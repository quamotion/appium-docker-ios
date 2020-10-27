#!/bin/sh

# Make sure /var/run/usbmuxd exists
if [ ! -S /var/run/usbmuxd ];
then
    echo "The /var/run/usbmuxd socket does not exist. Make sure usbmuxd is running on your host, and you mounted"
    echo "/var/run/usbmuxd in your Docker container."
    exit 1
fi

if [ ! -f /etc/quamotion/quamotion.developerprofile ];
then
    echo "You did not provide a developer profile. Please mount your developer profile"
    echo "to /etc/quamotion/quamotion.developerprofile, and try again."
    exit 1
fi

if [ -z "${DEVELOPER_PROFILE_PASSWORD}" ];
then
    echo "You did not specify a password for use with your developer profile."
    echo "Please set the DEVELOPER_PROFILE_PASSWORD environment variable, and try"
    echo "again."
    exit 1
fi

if [ ! -f /etc/quamotion/.license ];
then
    echo "You have not specified a license file."
    echo "Without license you can only use the container for 5 minutes."
    echo "Please mount your license file"
    echo "into /etc/quamotion/.license, and try again"
fi

exec appium