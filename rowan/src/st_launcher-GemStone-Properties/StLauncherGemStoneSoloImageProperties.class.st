Class {
	#name : 'StLauncherGemStoneSoloImageProperties',
	#superclass : 'StLauncherGemStoneCommonImageProperties',
	#instVars : [
		'soloSnapshot'
	],
	#category : 'st_launcher-GemStone-Properties'
}

{ #category : 'accessing' }
StLauncherGemStoneSoloImageProperties class >> platformName [

	^ 'gemstone'
]

{ #category : 'accessing' }
StLauncherGemStoneSoloImageProperties class >> platformType [

	^ 'gemstoneSolo'
]

{ #category : 'launcher' }
StLauncherGemStoneSoloImageProperties >> generateVmScriptLaunchCommandLineFrom: vmArgs vmScriptPath: scriptFilePath debugCommandError: debugCommandErrorBool [

	"fabricate a topaz command line for executing the stashFile using a solo extent"

	| theVmArgs |
	theVmArgs := vmArgs isEmpty 
		ifTrue: [ ' -lq'  ]
		ifFalse: [ vmArgs ].
	GsFile stdout 
		nextPutAll: 'export GEMSTONE="', self productDirectory pathString, '"';
		lf;
		nextPutAll: (self productDirectory / 'bin' / 'topaz' ) pathString;
		nextPutAll: ' -I ', (self imageDirectory / self topaziniFilename) pathString;
		nextPutAll: ' -C "GEM_SOLO_EXTENT=';
		nextPutAll: self soloSnapshot;
		nextPutAll: '"';
		nextPutAll: ' -S ', scriptFilePath;
		nextPutAll: ' ', theVmArgs;
		lf;
		yourself.
]

{ #category : 'testing' }
StLauncherGemStoneSoloImageProperties >> isTopazSolo [

	^true
]

{ #category : 'accessing' }
StLauncherGemStoneSoloImageProperties >> soloSnapshot [

	^ soloSnapshot
]

{ #category : 'accessing' }
StLauncherGemStoneSoloImageProperties >> soloSnapshot: aStringOrFileRef [

	soloSnapshot := aStringOrFileRef asFileReference resolve pathString	"resolve any env vars that may be present in path"
]

{ #category : 'testing' }
StLauncherGemStoneSoloImageProperties >> supportsTopazSFlag [
	"-S flag supported in 3.5.0 and later"

	^ true
]

{ #category : 'actions' }
StLauncherGemStoneSoloImageProperties >> writeTopaziniFileEntries: fileStream [

	super writeTopaziniFileEntries: fileStream.
	fileStream 
		nextPutAll: 'set solologin true';
		lf;
		yourself
]
