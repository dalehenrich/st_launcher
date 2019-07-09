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
			| launcherProperties imageProperties snapshots platformVersionString |
			launcherProperties := StLauncherProperties defaultPropertyFile.
			opts at: 'clean' ifPresent: [
				"clean up old directory structure"
				StLauncherCommon _deleteStructure.
			].
			opts at: 'version' ifPresent: [:version |
				"smalltalk platform version string, used with several other options"
				platformVersionString := version ].
			opts at: 'download' ifPresent: [:version |
				"download and create a product tree"
				StLauncherPlatform 
					download: (version ifNil: [ platformVersionString ])
					platform: 'gemstone'
			].
			opts at: 'create' 
				ifPresent: [:imageName |
					imageProperties := StLauncherPlatform 
						createImageNamed: (imageName ifNil: [ launcherProperties defaultImageName ])
						platform: 'gemstone'
						version: platformVersionString.
				].
			opts at: 'snapshot' ifPresent: [
				"create snapshot that can be used as solo extent"
				imageProperties 
					ifNil: [ imageProperties := launcherProperties imageMap at: launcherProperties defaultImageName ].
				snapshots := (StLauncher_GemStone_Snapshot_Script new)
					resumeCheckpoints;
					takeSnapshots: imageProperties name, '.dbf' 
					to: imageProperties snapshotsDirectory
					suspendInMinutes: 15 
					safely: false.
			].
		] 
    ifPresent: [ ^ self usage ]
]

{ #category : 'script execution' }
StLauncher_GemStone_UTILITY_Script >> scriptOptions [
	^ {
			#('help' $h #'none').
			#('clean' nil #'none').
			#('create' nil #'optional').
			#('snapshot' nil #'none').
			#('version' nil #'required').
			#('download' nil #'optional').
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

	Script for creating a GemStone image.

EXAMPLES
	./utility.st --help -- st_launcher_350 -lq

	./utility.st --clean -- st_launcher_350 -lq
	./utility.st --clean --create --version=3.5.0 -- st_launcher_350 -lq
	./utility.st --clean --create="gs_350" --version=3.5.0 --snapshot -- st_launcher_350 -lq
	./utility.st --clean --create= --snapshot -- st_launcher_350 -lq

	./utility.st --download="3.5.0" -- st_launcher_350 -lq
') printString, dashes
]
