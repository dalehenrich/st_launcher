#!/usr/local/bin/smalltalk/gemstone/stash
"
a Stash Script
"
Class {
	#name : 'StLauncher_GemStone_Snapshot',
	#superclass : 'StashScript',
	#category : 'st_launcher-GemStone-Scripts'
}

{ #category : 'script execution' }
StLauncher_GemStone_Snapshot >> executeScript [
	"Called to initiate execution of the script"
	^ opts
			at: 'help'
			ifAbsent: [ 
'PUT YOUR SCRIPT CODE HERE'
				 ]
			ifPresent: [ self usage ]
]

{ #category : 'script execution' }
StLauncher_GemStone_Snapshot >> scriptOptions [
	"specify the command line options"
	^ {
			#('help' $h #none).
	}
]

{ #category : 'usage' }
StLauncher_GemStone_Snapshot >> usage [
	"Man page for script"
	| dashes |
	dashes := '----------------------------------------------------
'.
	^ GsFile stdout nextPutAll: dashes,
		(self manPageClass
			fromString:
'NAME
	StLauncher_GemStone_Snapshot.st - example script, that can be used as a template to create your own script
SYNOPSIS
	StLauncher_GemStone_Snapshot.st [-h|--help] -- <topaz-arguments>

DESCRIPTION

	This StLauncher_GemStone_Snapshot.st is set up with help (--help).

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
	StLauncher_GemStone_Snapshot.st --help -- MyStone -lq								# GsDevKit_home
	StLauncher_GemStone_Snapshot.st --help -- -lq									# GEMSTONE
	StLauncher_GemStone_Snapshot.st --help -- MyStone -lq -C "GEM_SOLO_EXTENT=$GEMSTONE/bin/extent0.solo.dbf" --solo	# SOLO
	StLauncher_GemStone_Snapshot.st -h -- -lq										# GEMSTONE


') printString, dashes
]
