# st_launcher

## Installation/Bootstrap
### Using GsDevKit_home and stash

```
export GEMSTONE_NAME="st_launcher_350"
export GIT_HOME="$GS_HOME/shared/repos"

if [ ! -d "$GS_HOME/server/stones/$GEMSTONE_NAME" ] ; then
	createStone -G $GEMSTONE_NAME 3.5.0
else
	newExtent -s $GS_HOME/server/stones/$GEMSTONE_NAME/product/bin/extent0.dbf $GEMSTONE_NAME
fi

$GIT_HOME/st_launcher/bootstrapping/gemstone/bin/bootstrap_install.tpz $GEMSTONE_NAME -lq

$GIT_HOME/st_launcher/utility.gs.st --clean --create="3.5.0" --solo -- $GEMSTONE_NAME -lq
```

### references
- [mpw/stsh](https://github.com/mpw/stsh)
- [guillep/PharoBootstrap](https://github.com/guillep/PharoBootstrap/tree/master/scripts)
- [guillep/scale](https://github.com/guillep/Scale)
- [dalehenrich/stash](https://github.com/dalehenrich/stash)
- [pharo-project/pharo-launcher](https://github.com/pharo-project/pharo-launcher)
