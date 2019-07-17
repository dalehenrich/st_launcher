#! /usr/bin/env bash
#=========================================================================
# Copyright (c) 2019 GemTalk Systems, LLC <dhenrich@gemtalksystems.com>.
#
#   MIT license: https://github.com/dalehenrich/st_launcher/blob/masterV0.0/LICENSE
#=========================================================================

set -x # so you can see what's going on 

curl -L "https://github.com/kward/shunit2/archive/v2.1.7.tar.gz" | tar zx -C $TRAVIS_BUILD_DIR/travis_tests
git clone https://github.com/GemTalk/Rowan.git travis_tests/Rowan
curl  -O -s -S "https://downloads.gemtalksystems.com/pub/GemStone64/3.5.0/GemStone64Bit3.5.0-x86_64.Linux.zip"
mkdir $ST_LAUNCHER_HOME/platforms/gemstone
mkdir $ST_LAUNCHER_HOME/platforms/gemstone/downloads
mkdir $ST_LAUNCHER_HOME/platforms/gemstone/products
unzip -q -d "$ST_LAUNCHER_HOME/platforms/gemstone/products" GemStone64Bit3.5.0-x86_64.Linux.zip
mv GemStone64Bit3.5.0-x86_64.Linux.zip $ST_LAUNCHER_HOME/platforms/gemstone/downloads
curl  -L -O -s -S "https://github.com/dalehenrich/st_launcher/releases/download/v0.0.1/st_launcher_default.env"
curl  -L -O -s -S "https://github.com/dalehenrich/st_launcher/releases/download/v0.0.1/st_launcher_home.ston"
curl  -L -O -s -S "https://github.com/dalehenrich/st_launcher/releases/download/v0.0.1/extent0.admin_gs_350.dbf.zip"
sudo ls -altr $HOME
sudo mkdir $HOME/.st_launcher
sudo mv st_launcher_default.env st_launcher_home.ston $HOME/.st_launcher
unzip -q -d "$ST_LAUNCHER_HOME/images/admin_gs_350/snapshots" extent0.admin_gs_350.dbf.zip
sudo mkdir /usr/local/bin/smalltalk
sudo mkdir /usr/local/bin/smalltalk/gemstone
sudo ln -s $TRAVIS_BUILD_DIR/interpreters/st_launcher /usr/local/bin/smalltalk/gemstone/st_launcher 
sudo ln -s $TRAVIS_BUILD_DIR/interpreters/st_topaz_launcher /usr/local/bin/smalltalk/gemstone/st_topaz_launcher
