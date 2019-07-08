Class {
	#name : 'StLauncherGemStoneImageProperties',
	#superclass : 'StLauncherImageProperties',
	#instVars : [
		'gemstoneVersion',
		'statsPath',
		'tranlogsPath',
		'backupsPath',
		'logsPath',
		'binPath',
		'extentsPath',
		'snapshotsPath',
		'soloSnapshot',
		'productPath'
	],
	#category : 'st_launcher-GemStone-Properties'
}

{ #category : 'instance creation' }
StLauncherGemStoneImageProperties class >> named: nameString version: gemstoneVersionString [

	^ (self new)
		name: nameString;
		gemstoneVersion: gemstoneVersionString;
		yourself
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties class >> platformName [

	^ 'gemstone'
]

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

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> binDirectory [

	^ self imageDirectory / self binPath
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> binPath [

	^ binPath ifNil: [ binPath := 'bin' ]
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> binPath: aString [

	binPath := aString
]

{ #category : 'actions' }
StLauncherGemStoneImageProperties >> createStandardStructure [
	"create standard directory structure on disk"

	super createStandardStructure.
	self statsDirectory exists ifFalse: [ self createStatsDirectoryStructure ].
	self tranlogsDirectory exists ifFalse: [ self tranlogsDirectory ensureCreateDirectory ].
	self backupsDirectory exists ifFalse: [ self backupsDirectory ensureCreateDirectory ].
 	self logsDirectory exists ifFalse: [ self logsDirectory ensureCreateDirectory ].
	self binDirectory exists ifFalse: [ self binDirectory ensureCreateDirectory ].
	self extentsDirectory exists ifFalse: [ self extentsDirectory ensureCreateDirectory ].
	self snapshotsDirectory exists ifFalse: [ self snapshotsDirectory ensureCreateDirectory ].
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
		logsPath;
		binPath;
		extentsPath;
		snapshotsPath;
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
StLauncherGemStoneImageProperties >> gemstoneVersion [

	^ gemstoneVersion
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> gemstoneVersion: aGemStoneVersionString [

	gemstoneVersion := aGemStoneVersionString
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> logsDirectory [

	^ self imageDirectory / self logsPath
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> logsPath [

	^ logsPath ifNil: [ logsPath := 'logs' ]
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> logsPath: aString [

	logsPath := aString
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> productDirectory [

	^ productPath asFileReference
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> productPath [

	^ productPath
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> productPath: aString [

	productPath := aString
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> snapshotsDirectory [

	^ self imageDirectory / self snapshotsPath
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> snapshotsPath [

	^ snapshotsPath ifNil: [ snapshotsPath := 'snapshots' ]
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> snapshotsPath: aString [

	snapshotsPath := aString
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> soloSnapshot [

	^ soloSnapshot
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> soloSnapshot: aStringOrFileRef [

	soloSnapshot := aStringOrFileRef asFileReference resolve pathString	"resolve any env vars that may be present in path"
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

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> version [

	^ RwGemStoneVersionNumber fromString: self gemstoneVersion
]
