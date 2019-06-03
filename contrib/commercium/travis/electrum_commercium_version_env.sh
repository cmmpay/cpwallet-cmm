#!/bin/bash

VERSION_STRING=(`grep ELECTRUM_VERSION lib/version.py`)
ELECTRUM_commercium_VERSION=${VERSION_STRING[2]}
ELECTRUM_commercium_VERSION=${ELECTRUM_commercium_VERSION#\'}
ELECTRUM_commercium_VERSION=${ELECTRUM_commercium_VERSION%\'}
DOTS=`echo $ELECTRUM_commercium_VERSION |  grep -o "\." | wc -l`
if [[ $DOTS -lt 3 ]]; then
    ELECTRUM_commercium_APK_VERSION=$ELECTRUM_commercium_VERSION.0
else
    ELECTRUM_commercium_APK_VERSION=$ELECTRUM_commercium_VERSION
fi
export ELECTRUM_commercium_VERSION
export ELECTRUM_commercium_APK_VERSION
