Class {
	#name : 'StLauncherGemStoneProductProperties',
	#superclass : 'StLauncherProductProperties',
	#instVars : [
		'ftpSiteFilename',
		'ftpSiteDirectoryname',
		'downloadFilename',
		'osVersion'
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

	^ downloadFilename ifNil: [ downloadFilename := self productName ]
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> downloadFilename: alternateDownloadName [

	downloadFilename := alternateDownloadName
]

{ #category : 'ston' }
StLauncherGemStoneProductProperties >> excludedInstVarNames [

	^ #( ftpSiteFilename ftpSiteDirectoryname )
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

{ #category : 'testing' }
StLauncherGemStoneProductProperties >> isLinux [

	^ self osVersion = 'Linux-x86_64'
]

{ #category : 'testing' }
StLauncherGemStoneProductProperties >> isMac [

	^ self osVersion = 'Darwin-x86_64'
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> osVersion [

	^ osVersion 
		ifNil: [ 
			| uname |
			uname := StLauncherGemStoneSystem uname.
			uname = 'Darwin-i386'
				ifTrue: [ 
					"normalize mac os name"
					uname := 'Darwin-x86_64'].
			osVersion := uname ]
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> productVersionNameFor: aVersionString [

	| osExtension |
	osExtension := self isLinux
		ifTrue: [ '-x86_64.Linux' ]
		ifFalse: [
			self isMac
				ifTrue: [ '-i386.Darwin' ]
				ifFalse: [ self error: 'Unsupported platform ', self osVersion printString ] ].
	^ 'GemStone64Bit', aVersionString, osExtension
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> version [

	^ RwGemStoneVersionNumber fromString: self productVersionString
]
