#! /usr/bin/env bash
#=========================================================================
# Copyright (c) 2019 GemTalk Systems, LLC <dhenrich@gemtalksystems.com>.
#
#   MIT license: https://github.com/dalehenrich/st_launcher/blob/masterV0.0/LICENSE
#=========================================================================

set -x # so you can see what's going on 

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ..
st_launcher_HOME=`pwd`

st_launcherVersion="v0.0.1"

curl -L "https://github.com/kward/shunit2/archive/v2.1.7.tar.gz" | tar zx -C $st_launcher_HOME/travis_tests
git clone https://github.com/GemTalk/Rowan.git travis_tests/Rowan
pushd home
	cd platforms
	mkdir gemstone
	cd gemstone
	mkdir downloads products
	cd downloads
	curl  -O -s -S "https://downloads.gemtalksystems.com/pub/GemStone64/3.5.0/GemStone64Bit3.5.0-x86_64.Linux.zip"
  unzip -q -d "$st_launcher_HOME/home/platforms/gemstone/products" GemStone64Bit3.5.0-x86_64.Linux.zip
popd
pushd $HOME
	# \$TRAVIS_SDO is needed for travis-ci, since normally you don't have write permission in \$HOME
	if [ ! -d "$HOME/.st_launcher" ] ; then
		$TRAVIS_SUDO mkdir $HOME/.st_launcher
		cd $HOME/.st_launcher
	fi
popd
curl  -L -O -s -S "https://github.com/dalehenrich/st_launcher/releases/download/$st_launcherVersion/st_launcher_default.env"
curl  -L -O -s -S "https://github.com/dalehenrich/st_launcher/releases/download/$st_launcherVersion/st_launcher_home.ston"
$TRAVIS_SUDO mv st_launcher_default.env st_launcher_home.ston $HOME/.st_launcher
pushd home/images/admin_gs_350/snapshots
	curl  -L -O -s -S "https://github.com/dalehenrich/st_launcher/releases/download/$st_launcherVersion/extent0.admin_gs_350.dbf.zip"
	unzip -q  extent0.admin_gs_350.dbf.zip
popd
sudo mkdir /usr/local/bin/smalltalk
sudo mkdir /usr/local/bin/smalltalk/gemstone
sudo ln -s $st_launcher_HOME/interpreters/st_launcher /usr/local/bin/smalltalk/gemstone/st_launcher 
sudo ln -s $st_launcher_HOME/interpreters/st_topaz_launcher /usr/local/bin/smalltalk/gemstone/st_topaz_launcher 
