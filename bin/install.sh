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

st_launcherVersion="v0.1.1"

pushd $HOME
	if [ ! -d "$HOME/.config" ] ; then
		$TRAVIS_SUDO_COMMAND mkdir $HOME/.config
		$TRAVIS_SUDO_COMMAND chmod og-rwx $HOME/.config
		$TRAVIS_SUDO_COMMAND chmod u+rwx $HOME/.config
		$TRAVIS_SUDO_COMMAND chown $USER $HOME/.config
		ls -altrd  $HOME/.config
	fi
	if [ ! -d "$HOME/.config/st_launcher" ] ; then
		$TRAVIS_SUDO_COMMAND mkdir $HOME/.config/st_launcher
		$TRAVIS_SUDO_COMMAND chown $USER $HOME/.config/st_launcher
	fi
popd

curl -L "https://github.com/kward/shunit2/archive/v2.1.7.tar.gz" | tar zx -C $st_launcher_HOME/travis_tests
pushd home
	cd platforms
	mkdir gemstone
	cd gemstone
	mkdir downloads products
	cd downloads
	curl  -O -s -S "https://downloads.gemtalksystems.com/pub/GemStone64/3.5.0/GemStone64Bit3.5.0-x86_64.Linux.zip"
  unzip -q -d "$st_launcher_HOME/home/platforms/gemstone/products" GemStone64Bit3.5.0-x86_64.Linux.zip
popd
pushd home
	cd platforms
	mkdir pharo
	cd pharo
	mkdir 70-64
	cd 70-64
	curl https://get.pharo.org/64/stable+vm | bash
# Unfortunately this patch doesn't take effect unless the user logs out first
#		not useful for travis and should be left to the end user to decide
#	 avoid pthread warnings from pharo vms
#	cat <<END | sudo tee /etc/security/limits.d/pharo.conf
#*      hard    rtprio  2
#*      soft    rtprio  2
#END
popd

curl  -L -O -s -S "https://github.com/dalehenrich/st_launcher/releases/download/$st_launcherVersion/st_launcher_default.env"
sed -i "s/\$TRAVIS_BUILD_DIR/$st_launcher_HOME/g" st_launcher_default.env
curl  -L -O -s -S "https://github.com/dalehenrich/st_launcher/releases/download/$st_launcherVersion/st_launcher_home.ston"
sed -i "s/\$TRAVIS_BUILD_DIR/$st_launcher_HOME/g" st_launcher_home.ston
mv st_launcher_default.env st_launcher_home.ston $HOME/.config/st_launcher
pushd home/images/gemstone/snapshots
	curl  -L -O -s -S "https://github.com/dalehenrich/st_launcher/releases/download/$st_launcherVersion/extent0.gemstone.dbf.zip"
	unzip -q  extent0.gemstone.dbf.zip
popd
pushd home/images/pharo
	curl -L -O -s -S "https://github.com/dalehenrich/st_launcher/releases/download/$st_launcherVersion/pharo.zip"
	unzip -q pharo.zip
	rm pharo.zip
popd
if [ ! -d "/usr/local/bin/smalltalk" ] ; then
	$TRAVIS_SUDO_COMMAND mkdir /usr/local/bin/smalltalk
fi
if [ ! -d "/usr/local/bin/smalltalk/gemstone" ] ; then
	$TRAVIS_SUDO_COMMAND mkdir /usr/local/bin/smalltalk/gemstone
	$TRAVIS_SUDO_COMMAND ln -s $st_launcher_HOME/interpreters/st_launcher /usr/local/bin/smalltalk/gemstone/st_launcher 
	$TRAVIS_SUDO_COMMAND ln -s $st_launcher_HOME/interpreters/st_topaz_launcher /usr/local/bin/smalltalk/gemstone/st_topaz_launcher 
fi
