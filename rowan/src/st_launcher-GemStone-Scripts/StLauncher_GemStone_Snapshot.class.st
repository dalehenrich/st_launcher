#!/usr/local/bin/smalltalk/gemstone/stash
"
a Stash Script
"
Class {
	#name : 'StLauncher_GemStone_Snapshot',
	#superclass : 'StashScript',
	#instVars : [
		'checkpointService',
		'snapshotService'
	],
	#category : 'st_launcher-GemStone-Scripts'
}

{ #category : 'accessig' }
StLauncher_GemStone_Snapshot >> checkpointService [

	^ checkpointService ifNil: [ checkpointService := StLauncherPlatform checkpoints ]
]

{ #category : 'script execution' }
StLauncher_GemStone_Snapshot >> executeScript [

	opts
		at: 'help'
    ifAbsent: [
			| snapshotExtension snapshotPath suspendInMinutes safely snapShots |
			opts at: 'resume' ifPresent: [
				"resume snapshots, if they have already been suspended and the timeout hasn't expired yet"
				self resumeCheckpoints.
				GsFile stdout nextPutAll: 'Checkpoints resumed.'; lf.
				"allow --resume to be included on snapahot command line"
				args size < 1 ifTrue: [ ^ self ] ].
			args size < 1
				ifTrue: [ self error: 'Required argument <snapshot-extension> missing.' ].
			snapshotExtension := args at: 1.
			opts at: 'dir'
				ifPresent: [:arg | snapshotPath := arg ]
				ifAbsent: [ self error: 'Required option --dir missing.' ].
			suspendInMinutes := 15.
			safely := false.
			opts at: 'commit' ifPresent: [:ignored | self commit ].
			snapShots := self 
				takeSnapshots: snapshotExtension 
				to: snapshotPath 
				suspendInMinutes: suspendInMinutes 
				safely: safely.
			snapShots do: [:snapShotFileRef |
				| resultString |
				resultString := GsHostProcess execute: '/bin/chmod -w ', snapShotFileRef pathString.
				GsFile stdout nextPutAll: resultString ] ] 
    ifPresent: [ ^ self usage ]
]

{ #category : 'checkpoints' }
StLauncher_GemStone_Snapshot >> resumeCheckpoints [

	^ self checkpointService resumeCheckpoints
]

{ #category : 'script execution' }
StLauncher_GemStone_Snapshot >> scriptOptions [
	^ {
			#('help' $h #'none').
			#('safely' $s #'none').
			#('commit' $c #'none').
			#('suspend' $m #'required').
			#('dir' $d #'required').
			#('resume' nil #'none').
	}
]

{ #category : 'accessig' }
StLauncher_GemStone_Snapshot >> snapshotService [

	^ snapshotService ifNil: [ snapshotService := StLauncherPlatform snapshots ]
]

{ #category : 'snapshots' }
StLauncher_GemStone_Snapshot >> takeSnapshots: snapshotExtension to: snapshotDirPath suspendInMinutes: suspendInMinutes safely: safely [


	^ self snapshotService takeSnapshots: snapshotExtension to: snapshotDirPath suspendInMinutes: suspendInMinutes safely: safely
]

{ #category : 'usage' }
StLauncher_GemStone_Snapshot >> usage [
	| dashes |
	dashes := '----------------------------------------------------
'.
  GsFile stdout nextPutAll: dashes,
		(self manPageClass
          fromString:
'NAME
	snapshot - Make a snapshot of the extent files for the current stone.

SYNOPSIS
  snapshot.st [ --safely ] [ --suspend=<minutes> ] --resume \
		--dir=<snapshot-directory> <snapshot-extension>  -- <topaz-arguments>
  snapshot.st --resume  -- <topaz-arguments>

DESCRIPTION
  Make a snapshot copy of the extent files: 

    1. Suspend checkpoints. By default, checkpoints will be suspended for 15 
       minutes. If that may not be enough time, you can specify the number of 
       minutes to suspend the checkpoints with the --suspend option.
    2. Copy the extent files to the <snapshot-directory>. (replacing the `.dbf` 
       file extension with the given <snapshot-file-extension>).
    3. Resume checkpoints. Since checkpoints are explicitly resumed after the
       copies have been made, it does not hurt to be generous with the 
       --suspend option.
  
  With the --safely option specified, the snapshot will (quietly) be skipped if
  the target snapshot already exists.

  With the --commit options specificied, a commit will be performed before the 
  checkpoints are enabled. A commit is needed to ensure that checkpoint processing
  is not delayed (I think).

	`--resume`
		Resume checkpoints if they are currently suspended.

	`-- <topaz-arguments>`
		The command line arguments following the `--` will be passed to the topaz 
		shell interpreter that runs the script. Typically you will use the `-lq` 
		or `MyStone -lq` options to run scripts.

		If you want to use a solo session then you need to define the 
		`GEM_SOLO_EXTENT` configuration parameter in your gem.conf file or on the 
		command line using the `-C` option. The `--solo` option will then initiate a
		topaz solo login for the session: 
	
		-lq -C "GEM_SOLO_EXTENT=$GEMSTONE/bin/extent0.dbf" --solo

		GsDevKit_home
		-------------
		In the GsDevKit_home environment, the env var `$GS_HOME` must be dfined and
		the name of the stone must be supplied on the command line as the first 
		argument after the `--`.

		GEMSTONE
		--------
		If you are not using GsDevKit_home, then the env var `$GEMSTONE` must be
		defined, `$GEMSTONE/bin/topaz` must be in your `$PATH` env variable.

EXAMPLES
	snapshot.st --help -- MyStone -lq						# GsDevKit_home

	snapshot.st --dir=$GEMSTONE/data/snapshots solo.dbf -- -lq			# GEMSTONE
	snapshot.st --dir=$GS_HOME/gemstone/snapshots --commit solo.dbf -- MyStone -lq	# GsDevKit_home
	snapshot.st --dir=$GEMSTONE/data/snapshots --safely solo.dbf-- -lq		# GEMSTONE
	snapshot.st --dir=$GS_HOME/gemstone/snapshots solo.dbf	-- MyStone -lq		# GsDevKit_home
	snapshot.st --resume --dir=$GS_HOME/gemstone/snapshots solo.dbf	-- MyStone -lq	# GsDevKit_home

	snapshot.st --dir=./snapshots solo.dbf-- -lq					# GEMSTONE

	snapshot.st --resume -- MyStone -lq						# GsDevKit_home
') printString, dashes
]
