Class {
	#name : 'StLauncherGemStoneProductProperties',
	#superclass : 'StLauncherProductProperties',
	#instVars : [
		'ftpSiteFilename',
		'ftpSiteDirectoryname',
		'downloadFilename'
	],
	#category : 'st_launcher-GemStone-Properties'
}

{ #category : 'accessing' }
StLauncherGemStoneProductProperties class >> platformName [

	^ 'gemstone'
]

{ #category : 'actions' }
StLauncherGemStoneProductProperties >> createStandardStructure [
	"create standard directory structure on disk"

	super createStandardStructure.
	self downloads exists ifFalse: [ self downloads ensureCreateDirectory ].	"side effect is to create gemstone parent directory"
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> downloadFile [

	^ self downloads / self downloadFilename
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> downloadFilename [

	^ downloadFilename ifNil: [ 'not defined yet' ]
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> ftpSiteDirectoryname [

	^ ftpSiteDirectoryname ifNil: [ ftpSiteDirectoryname := self productVersionString ]
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> ftpSiteFilename [

	^ ftpSiteFilename ifNil: [ ftpSiteFilename := self productName ]
]

{ #category : 'initialize' }
StLauncherGemStoneProductProperties >> initialize [
	"noop"

	self createStandardStructure
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> productVersionNameFor: aVersionString [

	^ 'GemStone64Bit', aVersionString, '-x86_64.Linux'
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> version [

	^ RwGemStoneVersionNumber fromString: self productVersionString
]
