#!/usr/local/bin/smalltalk/gemstone/stash
"
a Stash Script
"
Class {
	#name : 'StLauncher_GemStone_UTILITY_Script',
	#superclass : 'StashScript',
	#category : 'st_launcher-GemStone-Scripts'
}

{ #category : 'script execution' }
StLauncher_GemStone_UTILITY_Script >> executeScript [

	opts
		at: 'help'
    ifAbsent: [
			| launcherProperties imageProperties snapshots |
			launcherProperties := StLauncherProperties defaultPropertyFile.
			opts at: 'clean' ifPresent: [
				"clean up old directory structure"
				StLauncherCommon _deleteStructure.
			].
			opts at: 'download' ifPresent: [:version |
				"download and create a product tree"
				StLauncherPlatform download: version platform: 'gemstone'
			].
			opts at: 'create' 
				ifPresent: [:version |
					imageProperties := StLauncherPlatform 
						createImageNamed: launcherProperties defaultImageName
						platform: 'gemstone'
						version: version.
				].
			opts at: 'solo' ifPresent: [
				"create snapshot for use as solo extent for default image ... use gzip compression to save space for deplyment/download"
				imageProperties 
					ifNil: [ imageProperties := launcherProperties imageMap at: launcherProperties defaultImageName ].
				snapshots := (StLauncher_GemStone_Snapshot_Script new)
					resumeCheckpoints;
					takeSnapshots: imageProperties name, '.dbf.gz' 
					to: imageProperties snapshotsDirectory
					suspendInMinutes: 15 
					safely: false.

				snapshots size > 1 
					ifTrue: [ 
						self error: 'A single snapshot file is needed for solo ... use a stone with a single extent to create snapshot' ].

				imageProperties 
					soloSnapshot: (snapshots at: 1);
					export;
					yourself.
			].
		] 
    ifPresent: [ ^ self usage ]
]

{ #category : 'script execution' }
StLauncher_GemStone_UTILITY_Script >> scriptOptions [
	^ {
			#('help' $h #'none').
			#('clean' nil #'none').
			#('create' nil #'required').
			#('solo' nil #'none').
			#('version' nil #'required').
			#('download' nil #'required').
	}
]

{ #category : 'usage' }
StLauncher_GemStone_UTILITY_Script >> usage [
	| dashes |
	dashes := '----------------------------------------------------
'.
  GsFile stdout nextPutAll: dashes,
		(self manPageClass
          fromString:
'NAME
	utility.st - Utility script.

SYNOPSIS
  utility.st [--help]

DESCRIPTION

	Test script for st_launcher.

EXAMPLES
	./utility.st --help -- st_launcher_350 -lq

	./utility.st --clean -- st_launcher_350 -lq
	./utility.st --clean --create="3.5.0" -- st_launcher_350 -lq
	./utility.st --clean --create="3.5.0" --solo -- st_launcher_350 -lq
	./utility.st --clean --create="3.5.0" --solo -- st_launcher_350 -lq

	./utility.st --download="3.5.0" -- st_launcher_350 -lq
') printString, dashes
]
