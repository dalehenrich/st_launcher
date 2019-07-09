Class {
	#name : 'StLauncherGemStoneCommonImageProperties',
	#superclass : 'StLauncherImageProperties',
	#instVars : [
		'gemstoneVersion',
		'logsPath',
		'binPath',
		'snapshotsPath',
		'productPath'
	],
	#category : 'st_launcher-GemStone-Properties'
}

{ #category : 'instance creation' }
StLauncherGemStoneCommonImageProperties class >> named: nameString version: gemstoneVersionString [

	^ (self new)
		name: nameString;
		gemstoneVersion: gemstoneVersionString;
		yourself
]

{ #category : 'accessing' }
StLauncherGemStoneCommonImageProperties >> binDirectory [

	^ self imageDirectory / self binPath
]

{ #category : 'accessing' }
StLauncherGemStoneCommonImageProperties >> binPath [

	^ binPath ifNil: [ binPath := 'bin' ]
]

{ #category : 'accessing' }
StLauncherGemStoneCommonImageProperties >> binPath: aString [

	binPath := aString
]

{ #category : 'actions' }
StLauncherGemStoneCommonImageProperties >> createStandardStructure [
	"create standard directory structure on disk"

	super createStandardStructure.
 	self logsDirectory exists ifFalse: [ self logsDirectory ensureCreateDirectory ].
	self binDirectory exists ifFalse: [ self binDirectory ensureCreateDirectory ].
	self snapshotsDirectory exists ifFalse: [ self snapshotsDirectory ensureCreateDirectory ].
]

{ #category : 'exporting' }
StLauncherGemStoneCommonImageProperties >> exportToStream: aStream [

	"lazily initialize any of the fields that haven't already been set, that need to be set"

	self 
		logsPath;
		binPath;
		snapshotsPath;
		yourself.
	super exportToStream: aStream
]

{ #category : 'accessing' }
StLauncherGemStoneCommonImageProperties >> gemstoneVersion [

	^ gemstoneVersion
]

{ #category : 'accessing' }
StLauncherGemStoneCommonImageProperties >> gemstoneVersion: aGemStoneVersionString [

	gemstoneVersion := aGemStoneVersionString
]

{ #category : 'launcher' }
StLauncherGemStoneCommonImageProperties >> generateVmScriptLaunchCommandLineFrom:  interpreterOptions vmArgs: vmArgs [

	"fabricate a topaz command line for executing the stashFile using a solo extent"

	GsFile stdout 
		nextPutAll: (self productDirectory / 'bin' / 'topaz' ) pathString;
		nextPutAll: vmArgs;
		lf;
		yourself.
]

{ #category : 'accessing' }
StLauncherGemStoneCommonImageProperties >> logsDirectory [

	^ self imageDirectory / self logsPath
]

{ #category : 'accessing' }
StLauncherGemStoneCommonImageProperties >> logsPath [

	^ logsPath ifNil: [ logsPath := 'logs' ]
]

{ #category : 'accessing' }
StLauncherGemStoneCommonImageProperties >> logsPath: aString [

	logsPath := aString
]

{ #category : 'accessing' }
StLauncherGemStoneCommonImageProperties >> productDirectory [

	^ productPath asFileReference
]

{ #category : 'accessing' }
StLauncherGemStoneCommonImageProperties >> productPath [

	^ productPath
]

{ #category : 'accessing' }
StLauncherGemStoneCommonImageProperties >> productPath: aString [

	productPath := aString
]

{ #category : 'accessing' }
StLauncherGemStoneCommonImageProperties >> snapshotsDirectory [

	^ self imageDirectory / self snapshotsPath
]

{ #category : 'accessing' }
StLauncherGemStoneCommonImageProperties >> snapshotsPath [

	^ snapshotsPath ifNil: [ snapshotsPath := 'snapshots' ]
]

{ #category : 'accessing' }
StLauncherGemStoneCommonImageProperties >> snapshotsPath: aString [

	snapshotsPath := aString
]

{ #category : 'accessing' }
StLauncherGemStoneCommonImageProperties >> version [

	^ RwGemStoneVersionNumber fromString: self gemstoneVersion
]