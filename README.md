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
export TRAVIS_BUILD_DIR=`pwd`
export ST_LAUNCHER_HOME=`pwd`/home
bin/install.sh
```

### Examples
The following examples are intended to illustrate different features of st_launcher scripts.

#### bin/hello.st
```
cat bin/hello.st         # view the hello.st source
bin/hello.st -h          # view the help for bin/hello.st
bin/hello.st             # execute bin/hello.st using the default image (gemstone
bin/hello.st pharo --    # execute bin/hello.st using the pharo (headless) image
bin/hello.st gemstone -- # execute bin/hello.st using the gemstone image
```
#### bin/error.st
```
cat bin/error.st            # view error.st source
bin/error.st --help         # view the help for bin/error.st
bin/error.st                # execute bin/error.st using the default image (gemstone)
bin/error.st pharo --       # execute bin/error.st using the pharo (headless) image
bin/error.st gemstone --    # execute bin/error.st using the gemstone image
bin/error.st pharo -D --    # execute bin/error.st using the pharo image and debug flag (exit pharo without saving)
bin/error.st gemstone -D -- # execute bin/error.st using the gemstone image and debug flag (type quit to exit the GemStone debugger)
```
#### ws/array.st
```
cat ws/array.st         # vi array.st source
ws/array.st -h          # view the help for ws/array.st
ws/array.st gemstone -- # execute ws/array.st using the gemstone image
ws/array.st pharo --    # execute ws/array.st using the pharo image
```
#### bin/listImages.st
```
cat bin/listImages.st         # view the source for bin/listImages.st
bin/listImages.st -h          # view the help for bin/listImages.st
bin/listImages.st gemstone -- # execute bin/listImages.st using the gemstone image
bin/listImages.st pharo --    # execute bin/listImages.st using the pharo image
```
#### bin/about.st
```
cat bin/about.st         # view the source for bin/about.st
bin/about.st -h          # view the help for bin/about.st
bin/about.st gemstone -- # execute bin/about.st using the gemstone image
bin/about.st pharo --    # execute bin/about.st using the pharo image
```

#### ws/gsClassesAndMethodCounts.st
```
cat ws/gsClassesAndMethodCounts.st      # view the source for ws/gsClassesAndMethodCounts.st
ws/gsClassesAndMethodCounts.st -h       # view the help for ws/gsClassesAndMethodCounts.st
ws/gsClassesAndMethodCounts.st          # execute ws/gsClassesAndMethodCounts.st using the default image (gemstone)
ws/gsClassesAndMethodCounts.st gemstone # execute ws/gsClassesAndMethodCounts.st using the gemstone image
```
#### bin/pie.pharo.st
```
cat bin/pie.pharo.st                                                      # view the source for bin/pie.pharo.st
bin/pie.pharo.st -h                                                       # view the help for bin/pie.pharo.st
ws/gsClassesAndMethodCounts.st | bin/pie.pharo.st pharo-ui -- --label=off # pipe output of ws/gsClassesAndMethodCounts.st into bin/pie.pharo.st and display pie charg
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
