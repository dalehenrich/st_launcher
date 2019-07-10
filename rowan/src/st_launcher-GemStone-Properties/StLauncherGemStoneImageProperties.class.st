Class {
	#name : 'StLauncherGemStoneImageProperties',
	#superclass : 'StLauncherGemStoneCommonImageProperties',
	#instVars : [
		'statsPath',
		'tranlogsPath',
		'backupsPath',
		'extentsPath'
	],
	#category : 'st_launcher-GemStone-Properties'
}

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> backupsDirectory [

	^ self imageDirectory / self backupsPath
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> backupsPath [

	^ backupsPath ifNil: [ backupsPath := 'backups' ]
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> backupsPath: aString [

	backupsPath := aString
]

{ #category : 'actions' }
StLauncherGemStoneImageProperties >> createStandardStructure [
	"create standard directory structure on disk"

	super createStandardStructure.
	self statsDirectory exists ifFalse: [ self createStatsDirectoryStructure ].
	self tranlogsDirectory exists ifFalse: [ self tranlogsDirectory ensureCreateDirectory ].
	self backupsDirectory exists ifFalse: [ self backupsDirectory ensureCreateDirectory ].
	self extentsDirectory exists ifFalse: [ self extentsDirectory ensureCreateDirectory ].
]

{ #category : 'actions' }
StLauncherGemStoneImageProperties >> createStatsDirectoryStructure [

	self statsSubdirectoryNames do: [:dirName |
		| dir |
		dir := self statsDirectory / dirName.
		dir exists ifFalse: [ dir ensureCreateDirectory ] ]
]

{ #category : 'exporting' }
StLauncherGemStoneImageProperties >> exportToStream: aStream [

	"lazily initialize any of the fields that haven't already been set, that need to be set"

	self 
		statsPath;
		tranlogsPath;
		backupsPath;
		extentsPath;
		yourself.
	super exportToStream: aStream
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> extentsDirectory [

	^ self imageDirectory / self extentsPath
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> extentsPath [

	^ extentsPath ifNil: [ extentsPath := 'extents' ]
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> extentsPath: aString [

	extentsPath := aString
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> statsDirectory [

	^ self imageDirectory / self statsPath
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> statsPath [

	^ statsPath ifNil: [ statsPath := 'stats' ]
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> statsPath: aString [

	statsPath := aString
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> statsSubdirectoryNames [

	^ #( '1-second' '60-second' )
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> tranlogsDirectory [

	^ self imageDirectory / self tranlogsPath
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> tranlogsPath [

	^ tranlogsPath ifNil: [ tranlogsPath := 'tranlogs' ]
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> tranlogsPath: aString [

	tranlogsPath := aString
]
