#!/bin/bash

source ./contrib/commercium/travis/electrum_commercium_version_env.sh;
echo wine build version is $ELECTRUM_commercium_VERSION

mv /opt/zbarw $WINEPREFIX/drive_c/
cd $WINEPREFIX/drive_c/cpwallet-cmm

rm -rf build
rm -rf dist/cpwallet-cmm

cp contrib/commercium/deterministic.spec .
cp contrib/commercium/pyi_runtimehook.py .
cp contrib/commercium/pyi_tctl_runtimehook.py .

wine pip install -r contrib/commercium/requirements.txt
wine pip install --upgrade pip==18.1
wine pip install PyInstaller==3.4

wine pip install cython=0.29.3
wine pip install hidapi
wine pip install pycryptodomex==3.6.0
wine pip install btchip-python==0.1.28
wine pip install keepkey==4.0.2

wine pip install rlp==0.6.0
wine pip install trezor==0.9.1

mkdir $WINEPREFIX/drive_c/Qt
ln -s $PYHOME/Lib/site-packages/PyQt5/ $WINEPREFIX/drive_c/Qt/5.5.1

wine pyinstaller -y \
    --name cpwallet-cmm-$ELECTRUM_commercium_VERSION.exe \
    deterministic.spec

if [[ $WINEARCH == win32 ]]; then
    NSIS_EXE="$WINEPREFIX/drive_c/Program Files/NSIS/makensis.exe"
else
    NSIS_EXE="$WINEPREFIX/drive_c/Program Files (x86)/NSIS/makensis.exe"
fi

wine "$NSIS_EXE" /NOCD -V3 \
    /DPRODUCT_VERSION=$ELECTRUM_commercium_VERSION \
    /DWINEARCH=$WINEARCH \
    contrib/commercium/cpwallet-cmm.nsi
