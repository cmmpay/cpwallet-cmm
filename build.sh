#!/bin/bash
set -ev

if [[ -z $TRAVIS_TAG ]]; then
  echo TRAVIS_TAG unset, exiting
  exit 1
fi

BUILD_REPO_URL=https://github.com/cmmpay/cpwallet-cmm

cd build

git clone --branch $TRAVIS_TAG $BUILD_REPO_URL cpwallet-cmm

sudo docker run --rm \
    -v $(pwd):/opt \
    -w /opt/cpwallet-cmm \
    -t zebralucky/electrum-dash-winebuild:Linux ./contrib/commercium/travis/build_linux.sh

sudo find . -name '*.po' -delete
sudo find . -name '*.pot' -delete

export WINEARCH=win32
export WINEPREFIX=/root/.wine-32
export PYHOME=$WINEPREFIX/drive_c/Python36

wget https://github.com/zebra-lucky/zbarw/releases/download/20180620/zbarw-zbarcam-0.10-win32.zip
unzip zbarw-zbarcam-0.10-win32.zip && rm zbarw-zbarcam-0.10-win32.zip

sudo docker run --rm \
    -e WINEARCH=$WINEARCH \
    -e WINEPREFIX=$WINEPREFIX \
    -e PYHOME=$PYHOME \
    -v $(pwd):/opt \
    -v $(pwd)/cpwallet-cmm/:$WINEPREFIX/drive_c/cpwallet-cmm \
    -w /opt/cpwallet-cmm \
    -t zebralucky/electrum-dash-winebuild:WinePy36 ./contrib/commercium/travis/build_wine.sh

export WINEARCH=win64
export WINEPREFIX=/root/.wine-64
export PYHOME=$WINEPREFIX/drive_c/Python36

wget https://github.com/zebra-lucky/zbarw/releases/download/20180620/zbarw-zbarcam-0.10-win64.zip
unzip zbarw-zbarcam-0.10-win64.zip && rm zbarw-zbarcam-0.10-win64.zip

sudo docker run --rm \
    -e WINEARCH=$WINEARCH \
    -e WINEPREFIX=$WINEPREFIX \
    -e PYHOME=$PYHOME \
    -v $(pwd):/opt \
    -v $(pwd)/cpwallet-cmm/:$WINEPREFIX/drive_c/cpwallet-cmm \
    -w /opt/cpwallet-cmm \
    -t zebralucky/electrum-dash-winebuild:WinePy36 ./contrib/commercium/travis/build_wine.sh
