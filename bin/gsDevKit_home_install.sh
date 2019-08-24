set -e
. defStone.env

rm -rf *.log *.out

newExtent -s product/bin/extent0.dbf $GEMSTONE_NAME

$ROWAN_PROJECTS_HOME/st_launcher/bootstrapping/gemstone/bin/bootstrap_install.tpz $GEMSTONE_NAME -lq

#	./utility.gs.st --clean -- $GEMSTONE_NAME -lq
#	./utility.gs.st --create=stl_350 --version=3.5.0 --snapshot -- $GEMSTONE_NAME -lq
#	./utility.gs.st --createSolo=solo_350 --sourceImage=stl_350 -- $GEMSTONE_NAME -lq

# Shrink the extent
if [ "false" = "true" ] ; then
	echo "SHRINKING THE EXTENT"
	./backup.tpz $GEMSTONE_NAME -- -lq -- "backups/extent0.${GEMSTONE_NAME}.dbf"
newExtent -s product/bin/extent0.dbf $GEMSTONE_NAME
	./restore.tpz $GEMSTONE_NAME -- -lq -- "backups/extent0.${GEMSTONE_NAME}.dbf"
	./shrink.tpz $GEMSTONE_NAME -- -lq 
else
	echo "skip SHRINKING THE EXTENT"
fi

./utility_old.gs.st --clean -- $GEMSTONE_NAME -lq

# create solo snapshot and copy it to where it needs to be for use and deployment
./snapshot.gs.st --dir=snapshots gemstone.dbf -- ${GEMSTONE_NAME} -lq
cp -f ./snapshots/extent0.gemstone.dbf /home/dhenrich/rogue/_homes/rogue/_home/shared/repos/st_launcher/home/images/gemstone/snapshots/
cp -f ./snapshots/extent0.gemstone.dbf ~/st_launcher_junk/extent0.gemstone.dbf

pushd ~/st_launcher_junk
	zip extent0.gemstone.dbf.zip extent0.gemstone.dbf
popd

pushd $ROWAN_PROJECTS_HOME/st_launcher/home/images/pharo
	if [ -e "Pharo.image" ] ; then
		mv Pharo.image Pharo.bak.image
		mv Pharo.changes Pharo.bak.changes
	fi
	cp ../../platforms/pharo/70-64/Pharo.image .
	cp ../../platforms/pharo/70-64/Pharo.changes .
	./pharo Pharo.image metacello install tonel:///home/dhenrich/rogue/_homes/rogue/_home/shared/repos/st_launcher/rowan/src BaselineOfSt_launcher 
	./pharo Pharo.image metacello install github://ObjectProfile/Roassal2/src BaselineOfRoassal2
	echo ""
	echo "prepare pharo image for script use"
	./pharo Pharo.image eval --save DebugSession logDebuggerStackToFile: false. GTGenericStackDebugger logDebuggerStackToFile: false. World closeAllUnchangedWindows.
	rm -f ~/st_launcher_junk/pharo.zip
	zip --symlinks ~/st_launcher_junk/pharo.zip Pharo.changes Pharo.image pharo-vm *.sources
popd

pushd $ROWAN_PROJECTS_HOME/st_launcher
	$ROWAN_PROJECTS_HOME/st_launcher/travis_tests/st_launcher_tests.sh
popd

