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
	self topaziniFile exists ifFalse: [ self createTopaziniFile ]
]

{ #category : 'actions' }
StLauncherGemStoneCommonImageProperties >> createTopaziniFile [

	self topaziniFile writeStreamDo: [:fileStream |
		self writeTopaziniFileEntries: fileStream ]
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
StLauncherGemStoneCommonImageProperties >> generateLaunchScriptFrom: scriptFilePath  debugCommandError: debugCommandErrorBool [

	| scriptFile script |
	scriptFile := scriptFilePath asFileReference.
	scriptFile readStreamDo: [:fileStream |
		script := fileStream contents ].
	scriptFile writeStreamDo: [:fileStream |
		debugCommandErrorBool
			ifTrue: [ fileStream nextPutAll: 'iferr 1 stk'; lf ]
			ifFalse: [ fileStream nextPutAll: 'iferr 1 exit 1'; lf ].
		fileStream
			nextPutAll: 'login'; lf;
			yourself.
false ifTrue: [
		"see https://github.com/dalehenrich/st_launcher/issues/4 ... affects exit status and cleanliness of output"
		fileStream
			nextPutAll: 'expectvalue true'; lf;
			yourself .
].
		fileStream
			nextPutAll: 'run'; lf;
			nextPutAll: script; lf;
			nextPutAll: '%'; lf;
			yourself.
		debugCommandErrorBool 
			ifTrue: [ 
				fileStream
					nextPutAll: 'EXITIFNOERROR'; lf;
					yourself ]
			ifFalse: [ 
				fileStream
					nextPutAll: 'EXIT'; lf;
					yourself ] ].
]

{ #category : 'launcher' }
StLauncherGemStoneCommonImageProperties >> generateVmScriptLaunchCommandLineFrom: vmArgs vmScriptPath: scriptFilePath debugCommandError: debugCommandErrorBool [

	"fabricate a topaz command line for executing the stashFile using a solo extent"

	| theVmArgs |
	theVmArgs := vmArgs isEmpty 
		ifTrue: [ '-lq' ]
		ifFalse: [ vmArgs ].
	GsFile stdout 
		nextPutAll: (self productDirectory / 'bin' / 'topaz' ) pathString;
		nextPutAll: ' -I ', (self imageDirectory / self topaziniFilename) pathString;
		nextPutAll: ' -S ', scriptFilePath;
		nextPutAll: ' ', theVmArgs;
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
StLauncherGemStoneCommonImageProperties >> topaziniFile [

	^ self imageDirectory / '.topazini'
]

{ #category : 'aliased properties' }
StLauncherGemStoneCommonImageProperties >> topaziniFilename [

	"answer the topazini file name to be used to launch this vm"

	^ self topaziniFilenameFor: self imageAlias
]

{ #category : 'aliased properties' }
StLauncherGemStoneCommonImageProperties >> topaziniFilenameFor: anImageNameOrAlias [

	"answer the topazini file name to be used to launch this vm"

	| default |
	default := '.topazini'.
	^ (self aliasProperties at: anImageNameOrAlias ifAbsent: [ ^ default ])
		at: 'topazini' ifAbsent: [ default ]
]

{ #category : 'accessing' }
StLauncherGemStoneCommonImageProperties >> version [

	^ RwGemStoneVersionNumber fromString: self gemstoneVersion
]

{ #category : 'actions' }
StLauncherGemStoneCommonImageProperties >> writeTopaziniFileEntries: fileStream [

	fileStream 
		nextPutAll: 'set GEMSTONE ', self name;	"shouldn't be needed, but seems to be required for 3.5.0"
		lf;
		nextPutAll: 'set user SystemUser';
		lf;
		nextPutAll: 'set password swordfish';
		lf;
		yourself
]
