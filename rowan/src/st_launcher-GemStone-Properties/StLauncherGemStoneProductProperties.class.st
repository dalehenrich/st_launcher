Class {
	#name : 'StLauncherGemStoneProductProperties',
	#superclass : 'StLauncherProductProperties',
	#instVars : [
		'ftpSiteFilename',
		'ftpSiteDirectoryname',
		'downloadFilename',
		'osVersion',
		'productFilename'
	],
	#category : 'st_launcher-GemStone-Properties'
}

{ #category : 'install / uninstall' }
StLauncherGemStoneProductProperties class >> _deleteStructure [

	| launcherProperties |
	launcherProperties := StLauncherProperties defaultPropertyFile.

	(launcherProperties gemstone) exists
		ifTrue: [ 
			launcherProperties gemstone children 
				do: [:ent | 
					ent isDirectory
						ifTrue: [ 
							(self permanentProducts includes: ent basename)
								ifFalse: [
									StLauncherGemStoneSystem chmod: ' +w -R ', (launcherProperties gemstone / 'products') pathString ].
									ent ensureDeleteAll.
									(launcherProperties at: self platformName ) removeKey: ent basename ifAbsent: [] ] ] ].
	launcherProperties export.
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties class >> permanentProducts [

	#( 'GemStone64Bit3.5.0-x86_64.Linux' )
]

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
StLauncherGemStoneProductProperties >> defaultPropertiesDirectory [

	^ self productDirectory
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> downloadFile [

	^ self downloads / self downloadFilename
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> downloadFilename [

	^ downloadFilename ifNil: [ downloadFilename := self productName, '.zip' ]
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> downloadFilename: alternateDownloadName [

	downloadFilename := alternateDownloadName
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> downloadHttpsUrl [

	^ 'https://downloads.gemtalksystems.com/pub/GemStone64/', self ftpSiteDirectoryname, '/', self ftpSiteFilename
]

{ #category : 'ston' }
StLauncherGemStoneProductProperties >> excludedInstVarNames [

	^ super excludedInstVarNames, #( ftpSiteFilename ftpSiteDirectoryname )
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> ftpSiteDirectoryname [

	^ ftpSiteDirectoryname ifNil: [ ftpSiteDirectoryname := self productVersionString ]
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> ftpSiteFilename [

	^ ftpSiteFilename ifNil: [ ftpSiteFilename := self productName,  '.zip' ]
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
StLauncherGemStoneProductProperties >> productDirectory [

	^ self products / self productFilename
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> productFile [

	^ self products / self productFilename
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> productFilename [

	^ productFilename ifNil: [ productFilename := self productName ]
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> productFilename: alternateProductName [

	productFilename := alternateProductName
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
