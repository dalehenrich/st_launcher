# st_launcher [![Build Status](https://travis-ci.org/dalehenrich/st_launcher.svg?branch=masterV0.1)](https://travis-ci.org/dalehenrich/st_launcher)

### Installation
After this install, you will be able to run scripts using the `gemstone` and `pharo` images.
The `gemstone` image is also the `default` image, so if you want to do development on `st_launher` itself, you will need to have Rowan and st_launcher installed in a GemStone stone. See [GsDevKit_home-based development](#gsdevkit_home-based-development) for additional installation instructions.

The following installation instructions are based on the installation processed that is used for [Travis-CI][1].
The environment variable `ROWAN_PROJECTS_HOME` is used by [Rowan][2] as the directory into which git clones will be downloaded.
The environment variable `ST_LAUNCHER_HOME` is currently used by the shell interpreter for st_launcher and needs to be set before running any scripts.
When the shell interpreter script is converted to pure smalltalk, `ST_LAUNCHER_HOME` will no longer be needed.

A [GemStone 3.5.0 product tree][3] is installed in `$ST_LAUNCHER_HOME/home/platforms/gemstone`.
A [Pharo 7.0.3 product tree][4] is installed in `$ST_LAUNCHER_HOME/home/platforms/pharo`.
`sudo` is used to install the shell interpreter scripts in `/usr/local/bin/smalltalk`.
This script creates a `$HOME/.config/st_launcher` directory where the st_launcher image registry (st_launcher_home.ston) will be located:
```
export ROWAN_PROJECTS_HOME=`pwd`
git clone https://github.com/dalehenrich/st_launcher.git
cd st_launcher
export TRAVIS_SUDO_COMMAND=sudo
export ST_LAUNCHER_HOME=`pwd`/home
bin/install.sh
```

### GsDevKit_home-based development
```smalltalk
./snapshot.gs.st --dir=./snapshots gemstone.dbf  -- st_launcher_350 -lq
cp -f snapshots/extent0.gemstone.dbf /home/dhenrich/rogue/_homes/rogue/_home/shared/repos/st_launcher/home/images/gemstone/snapshots/
```

[1]: https://travis-ci.org/dalehenrich/st_launcher
[2]: https://github.com/GemTalk/Rowan
[3]: https://gemtalksystems.com/products/gs64/versions35x/
[4]: https://pharo.org/news/pharo7.0-released
