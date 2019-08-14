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
			| launcherProperties imageProperties snapshots platformVersionString sourceImageName |
			launcherProperties := StLauncherProperties defaultPropertyFile.
			opts at: 'clean' ifPresent: [
				"clean up old directory structure"
				StLauncherCommon _deleteStructure.
			].
			opts at: 'version' ifPresent: [:version |
				"smalltalk platform version string, used with several other options"
				platformVersionString := version ].
			opts at: 'sourceImage' ifPresent: [:theImageName |
				"name of smalltalk platform image, used with several other options"
				sourceImageName := theImageName ].
			opts at: 'download' ifPresent: [:version |
				"download and create a product tree"
				StLauncherPlatform 
					download: (version ifNil: [ platformVersionString ])
					platform: 'gemstone'
			].
			opts at: 'createSolo' 
				ifPresent: [:theImageName |
					| snapshotPath sourceImageProperties  |
					sourceImageProperties := launcherProperties propertiesForImageNamed: sourceImageName.
					snapshotPath := sourceImageProperties snapshotsDirectory / ('extent0.', sourceImageName, '.dbf'). 
					imageProperties := StLauncherGemStonePlatform 
						createSoloImageNamed: (theImageName ifNil: [ launcherProperties defaultImageName ])
						comment: ''
						version: sourceImageProperties gemstoneVersion
						sourceSnapshotFile: snapshotPath.
				].
			opts at: 'create' 
				ifPresent: [:theImageName |
					imageProperties := StLauncherPlatform 
						createImageNamed: (theImageName ifNil: [ launcherProperties defaultImageName ])
						platform: 'gemstone'
						comment: ''
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
			#('createSolo' nil #'optional').
			#('snapshot' nil #'none').
			#('sourceImage' nil #'required').
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
	utility.gs.st - Utility script.

SYNOPSIS
  utility.gs.st [--help]

DESCRIPTION

	Script for creating a GemStone image.

EXAMPLES
	./utility.gs.st --help -- st_launcher_350 -lq

	./utility.gs.st --clean -- st_launcher_350 -lq

	./utility.gs.st --create=stl_350 --version=3.5.0 --snapshot -- st_launcher_350 -lq
	./utility.gs.st --createSolo=solo_350 --sourceImage=stl_350 -- st_launcher_350 -lq

	./utility.gs.st --clean --create --version=3.5.0 -- st_launcher_350 -lq
	./utility.gs.st --clean --create=stl_350 --version=3.5.0 --snapshot -- st_launcher_350 -lq

	./utility.gs.st --download="3.5.0" -- st_launcher_350 -lq
') printString, dashes
]
