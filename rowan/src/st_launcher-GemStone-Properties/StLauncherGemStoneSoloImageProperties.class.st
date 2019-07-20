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

{ #category : 'launcher' }
StLauncherGemStoneSoloImageProperties >> generateVmScriptLaunchCommandLineFrom: vmArgs debugCommandError: debugCommandErrorBool [

	"fabricate a topaz command line for executing the stashFile using a solo extent"

	| theVmArges |
	theVmArges := vmArgs isEmpty 
		ifTrue: [ ' -lq'  ]
		ifFalse: [ vmArgs ].
	GsFile stdout 
		nextPutAll: (self productDirectory / 'bin' / 'topaz' ) pathString;
		nextPutAll: theVmArges, ' -C "GEM_SOLO_EXTENT=';
		nextPutAll: self soloSnapshot;
		nextPutAll: '"';
		nextPutAll: ' -I ', self imageDirectory pathString, '/.topazini ';
		lf;
		yourself.
]

{ #category : 'accessing' }
StLauncherGemStoneSoloImageProperties >> soloSnapshot [

	^ soloSnapshot
]

{ #category : 'accessing' }
StLauncherGemStoneSoloImageProperties >> soloSnapshot: aStringOrFileRef [

	soloSnapshot := aStringOrFileRef asFileReference resolve pathString	"resolve any env vars that may be present in path"
]

{ #category : 'actions' }
StLauncherGemStoneSoloImageProperties >> writeTopaziniFileEntries: fileStream [

	super writeTopaziniFileEntries: fileStream.
	fileStream 
		nextPutAll: 'set solologin true';
		lf;
		yourself
]
