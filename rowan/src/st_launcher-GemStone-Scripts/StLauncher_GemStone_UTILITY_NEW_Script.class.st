#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
a Stash Script
"
Class {
	#name : 'StLauncher_GemStone_UTILITY_NEW_Script',
	#superclass : 'StLauncherScript',
	#instVars : [
		'platformVersionString',
		'sourceImageName',
		'imageProperties',
		'launcherProperties',
		'platformName',
		'snapshots'
	],
	#category : 'st_launcher-GemStone-Scripts'
}

{ #category : 'private' }
StLauncher_GemStone_UTILITY_NEW_Script >> _launcherProperties [

	launcherProperties ifNil: [ launcherProperties := StLauncherProperties defaultPropertyFile ]
]

{ #category : 'private' }
StLauncher_GemStone_UTILITY_NEW_Script >> _platformName [

	^ platformName ifNil: [ platformName := 'gemstone' ]
]

{ #category : 'actions' }
StLauncher_GemStone_UTILITY_NEW_Script >> clean [

	"clean up old directory structure"
	StLauncherCommon _deleteStructure.
]

{ #category : 'actions' }
StLauncher_GemStone_UTILITY_NEW_Script >> create: imageName [

	"create an image using the specified version of the platformName"

	opts at: 'version' ifAbsent: [ self error: 'required option --version not specified' ].
	imageProperties := StLauncherPlatform 
		createImageNamed: (imageName ifNil: [ self _launcherProperties defaultImageName ])
		platform: self _platformName
		comment: ''
		version: platformVersionString.
]

{ #category : 'actions' }
StLauncher_GemStone_UTILITY_NEW_Script >> createSolo: theImageName [

	"create a solo image using the snapshot from sourceImage"

	| snapshotPath sourceImageProperties  |
	opts at: 'sourceImage' ifAbsent: [ self commandError: 'The required options --sourceImage was not specified' ].
	sourceImageProperties := self _launcherProperties propertiesForImageNamed: sourceImageName.
	snapshotPath := sourceImageProperties snapshotsDirectory / ('extent0.', sourceImageName, '.dbf'). 
	imageProperties := StLauncherGemStonePlatform 
		createSoloImageNamed: (theImageName ifNil: [ self _launcherProperties defaultImageName ])
		version: sourceImageProperties gemstoneVersion
		sourceSnapshotFile: snapshotPath.
]

{ #category : 'actions' }
StLauncher_GemStone_UTILITY_NEW_Script >> download: versionString [

	"download and create a product tree"

	StLauncherPlatform 
		download: (versionString ifNil: [ platformVersionString ])
		platform: 'gemstone'
]

{ #category : 'actions' }
StLauncher_GemStone_UTILITY_NEW_Script >> platform: aString [

	"name of smalltalk platform, used with several other options"

	platformName := aString
]

{ #category : 'options' }
StLauncher_GemStone_UTILITY_NEW_Script >> scriptMethodOptions [
	^ {
			#('help' $h #'none' #usage).
			#('clean' nil #'none' #clean).
			#('version' nil #'required' #version:).
			#('sourceImage' nil #'required' #sourceImage:).
			#('platform' nil #required #platform:).
			#('download' nil #'optional' #download:).
			#('createSolo' nil #'optional' #createSolo:).
			#('create' nil #'optional' #create:).
			#('snapshot' nil #'none' #snapshot).
	}
]

{ #category : 'actions' }
StLauncher_GemStone_UTILITY_NEW_Script >> snapshot [

	"create snapshot that can be used as solo extent"

	imageProperties 
		ifNil: [ imageProperties := launcherProperties imageMap at: self _launcherProperties defaultImageName ].
	snapshots := (StLauncher_GemStone_Snapshot_Script new)
		resumeCheckpoints;
		takeSnapshots: imageProperties name, '.dbf' 
		to: imageProperties snapshotsDirectory
		suspendInMinutes: 15 
		safely: false.
]

{ #category : 'actions' }
StLauncher_GemStone_UTILITY_NEW_Script >> sourceImage: theImageName [

	"name of smalltalk platform image, used with several other options"

	sourceImageName := theImageName
]

{ #category : 'usage' }
StLauncher_GemStone_UTILITY_NEW_Script >> usage [
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

	./utility.gs.st --clean --create --version=3.5.0 --platform=gemstone -- st_launcher_350 -lq
	./utility.gs.st --clean --create=stl_350 --version=3.5.0 --snapshot -- st_launcher_350 -lq

	./utility.gs.st --download="3.5.0" -- st_launcher_350 -lq
') printString, dashes
]

{ #category : 'actions' }
StLauncher_GemStone_UTILITY_NEW_Script >> version: versionString [

	"smalltalk platform version string, used with several other actions"

	platformVersionString := versionString
]
